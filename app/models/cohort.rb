class Cohort < ActiveRecord::Base
  has_many :events
  has_many :attendances,  through: :events

  has_many :assignments
  has_many :submissions,  through: :assignments

  has_many :memberships,    dependent:  :destroy
  has_many :users,          through:    :memberships
  has_many :observations,   through:    :memberships

  # we use this to only show existing tags on the cohort tag form. The unique
  # is important becuase otherwise we'll get duplicates of tags
  has_many :existing_tags, -> {uniq},  through: :memberships, source: :tags

  belongs_to :course
  belongs_to :location

  scope :active, -> {where("end_date >= ?", Time.now)}
  scope :inactive, -> {where("end_date < ?", Time.now)}

  def has_admin? user
    self.admins.include?(user)
  end

  def student_memberships
    self.memberships.where(is_admin: false)
  end

  def admin_memberships
    self.memberships.where(is_admin: true)
  end

  def students
    self.student_memberships.map(&:user)
  end
  alias_method :nonadmins, :students

  def admins
    admin_memberships.map(&:user)
  end
  alias_method :instructors, :admins

  def add_admin(user)
    self.memberships.create!(user: user, is_admin: true)
  end

  def add_member(user, is_admin = false)
    self.memberships.create!(user: user, is_admin: is_admin)
  end
end
