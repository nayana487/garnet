class Cohort < ActiveRecord::Base
  has_many :events
  has_many :attendances,  through: :events

  has_many :assignments
  has_many :submissions,  through: :assignments

  has_many :memberships,  dependent:  :destroy
  has_many :users,        through:    :memberships
  has_many :observations, through:    :memberships

  belongs_to :course
  belongs_to :location

  def has_admin? user
    self.admins.include?(user)
  end

  def student_memberships
    self.memberships.where(is_owner: false)
  end

  def admin_memberships
    self.memberships.where(is_owner: true)
  end

  def students
    self.student_memberships.map(&:user)
  end
  alias_method :nonadmins, :students
  alias_method :nonowners, :students

  def admins
    admin_memberships.where(is_owner: true).map(&:user)
  end
  alias_method :owners, :admins
  alias_method :instructors, :admins

  def add_owner(user)
    self.memberships.create!(user: user, is_owner: true)
  end

  def add_member(user, is_owner = false)
    self.memberships.create!(user: user, is_owner: is_owner)
  end
end
