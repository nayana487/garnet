class Membership < ActiveRecord::Base
  enum status: [ :active, :inactive ]

  belongs_to :cohort
  belongs_to :user

  has_many :taggings
  has_many :tags, through: :taggings

  has_many :observations
  has_many :attendances
  has_many :submissions

  validate :is_unique_in_cohort, on: :create
  before_save :convert_nil_to_false

  def convert_nil_to_false
    self.is_admin = false unless self.is_admin == true
    return true
  end

  def is_unique_in_cohort
    if self.cohort.memberships.where(user_id: self.user_id).count > 0
      errors[:base].push("A user may have only one membership in a given cohort.")
    end
  end

  def name
    self.user.username
  end

  def toggle_active!
    self.active? ? self.inactive! : self.active!
  end

  def toggle_admin!
    self.update_attribute(:is_admin, !self.is_admin)
  end

end
