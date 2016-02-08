class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: true, format: {with: /\A[a-zA-Z0-9\-_]+\z/, message: "Only letters, numbers, hyphens, and underscores are allowed."}
  validates :github_id, allow_blank: true, uniqueness: true
  validate :validates_name_if_no_github_id

  has_many :memberships, dependent: :destroy
  has_many :cohorts, through: :memberships

  has_many :observations, through: :memberships
  has_many :admin_observations, class_name: "Observation", foreign_key: "admin_id"

  has_many :submissions, through: :memberships
  has_many :admin_submissions, class_name: "Submission", foreign_key: "admin_id"
  has_many :assignments, through: :submissions

  has_many :attendances, through: :memberships
  has_many :admin_attendances, class_name: "Attendance", foreign_key: "admin_id"
  has_many :events, through: :attendances

  has_and_belongs_to_many :adminned_locations, -> { uniq }, class_name: "Location", foreign_key: :user_id
  has_and_belongs_to_many :adminned_courses, -> { uniq }, class_name: "Course", foreign_key: :user_id

  before_save :downcase_username, :dont_update_blank_password
  after_save :accept_invite

  attr_accessor :password
  attr_accessor :invite_code

  def downcase_username
    self.username.downcase!
  end

  def validates_name_if_no_github_id
    if !self.github_id && self.name.strip.blank?
      errors[:base].push("Please include your full name!")
    end
  end

  def dont_update_blank_password
    if self.password && !self.password.strip.blank?
      self.password_digest = User.new_password(self.password)
    end
  end

  def to_param
    "#{self.username}"
  end

  def self.named username
    User.find_by(username: username)
  end

  def name
    read_attribute(:name) || self.username
  end

  def gh_url
    "https://www.github.com/#{self.username}" if self.github_id
  end

  def first_name
    return self.username.capitalize unless name.present?
    name.split.first.capitalize
  end

  def last_name
    return self.username.capitalize unless name.present?
    name.split.last.capitalize
  end

  def self.new_password password
    BCrypt::Password.create(password)
  end

  def password_ok? password
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def adminned_cohorts
    @adminned_cohorts ||= self.cohorts.includes(:memberships).where(memberships: {is_admin: true})
  end

  def cohorts_adminned_by user
    self.cohorts & user.adminned_cohorts
  end

  def is_admin_of_anything?
    self.memberships.exists?(is_admin: true)
  end

  def is_admin_of?(cohort)
    self.memberships.where(cohort: cohort, is_admin: true).any?
  end

  # returns all memberships in a cohort that you are an admin of, and
  # that share 1 or more tags in common with your admin membership
  def adminned_memberships_by_tag(cohort)
    membership = memberships.find_by(cohort: cohort, is_admin: true)
    return [] unless membership && membership.tag_ids.any?

    tag_ids = membership.tag_ids
    tagged_memberships = Membership.joins(:taggings).where(cohort: cohort).where(taggings: {tag_id: tag_ids})
    tagged_memberships.uniq
  end

  # Returns all submissions or assignments for memberships that a user is an
  # admin of, by tag, and that haven't been 'graded'.
  # For submissions, it means they aren't marked present/tardy/absent.
  # For assignments, it means they aren't been marked completed/incomplete/missing
  # Additionally, the due date or date of the associated event/assignment is taken
  # into consideration
  def get_todo model, cohort
    return [] unless model && cohort
    ids = adminned_memberships_by_tag(cohort).map(&:id)
    records = model.where(membership_id: ids).todo
  end

  def is_member_of cohort
    cohort.memberships.exists?(user: self)
  end

  private
  def accept_invite
    if self.invite_code
      cohort = Cohort.find_by(invite_code: self.invite_code)
      cohort.memberships.create(user: self)
    end
  end

end
