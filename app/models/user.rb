class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: true, format: {with: /\A[a-zA-Z0-9\-_]+\z/, message: "Only letters, numbers, hyphens, and underscores are allowed."}
  validates :github_id, allow_blank: true, uniqueness: true
  validate :validates_name_if_no_github_id

  has_many :memberships, dependent: :destroy
  has_many :groups, through: :memberships

  has_many :observations
  has_many :admin_observations, class_name: "Observation", foreign_key: "admin_id"

  has_many :submissions
  has_many :admin_submissions, class_name: "Submission", foreign_key: "admin_id"
  has_many :assignments, through: :submissions

  has_many :attendances
  has_many :admin_attendances, class_name: "Attendance", foreign_key: "admin_id"
  has_many :events, through: :attendances

  before_save :downcase_username, :dont_update_blank_password
  after_create :add_to_ga
  attr_accessor :password

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

  def add_to_ga
    @ga = Group.at_path("ga")
    # I know, I know.
    if !@ga
      @ga = Group.create(title: "ga")
    end
    Membership.create(user_id: self.id, group_id: @ga.id)
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

  def owned_groups
    @owned_groups ||= self.memberships.where(is_admin: true).collect(&:group)
  end

  def adminned_groups
    return @adminned_groups if defined? @adminned_groups
    @adminned_groups = []
    owned_groups.each do |group|
      @adminned_groups.push(group.descendants)
    end
    @adminned_groups = @adminned_groups.flatten.uniq
  end

  def groups_adminned_by user
    self.groups & user.adminned_groups
  end

  def records_accessible_by user, attribute_name
    records = self.send(attribute_name)
    my_groups = records.collect(&:group).uniq
    common_groups = my_groups & user.adminned_groups
    return records.select{|r| common_groups.include?(r.group)}
  end

  def is_admin_of_anything?
    self.memberships.select(&:is_admin).count > 0
  end

  def get_due model_name
    memberships = self.memberships.where(is_admin: true, is_priority: true)
    records = memberships.collect(&:group).collect{|g| g.send(model_name)}
    return records.flatten.select{|s| !s.status}
  end

end
