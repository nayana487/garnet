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

  def instructors
    self.memberships.where(is_owner: true).map(&:user)
  end
  alias_method :owners, :instructors
  alias_method :admins, :instructors

  def students
    self.memberships.where(is_owner: false).map(&:user)
  end
  alias_method :nonadmins, :students
  alias_method :nonowners, :students

end
