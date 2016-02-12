class Membership < ActiveRecord::Base
  enum status: [ :active, :inactive ]

  belongs_to :cohort
  has_many :taggings
  has_many :tags, through: :taggings

  belongs_to :user

  has_many :taggings
  has_many :tags, through: :taggings

  has_many :observations
  has_many :attendances
  has_many :submissions

  validate :is_unique_in_cohort, on: :create
  before_save :convert_nil_to_false

  scope :admin,   -> { where(is_admin: true) }
  scope :student, -> { where(is_admin: false) }
  scope :current, -> { joins(:cohort).where("cohorts.end_date <= ?", Time.now) } # TODO: not used -ab

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
    self.user.name
  end

  def toggle_active!
    self.active? ? self.inactive! : self.active!
  end

  def toggle_admin!
    self.update_attribute(:is_admin, !self.is_admin)
  end

  def percent_from_status( association, status)
    assoc = self.send(association)
    assoc = assoc.due if(association == :attendances)
    return nil if assoc.length == 0
    ((assoc.where(status:status).length.to_f / assoc.where.not(status:nil).length.to_f) * 100).round(0)
  end

  def average_observations
    average = (self.observations.map(&:status).inject(:+).to_f/(self.observations.length)).round(2)
    self.observations.any? ? average : nil
  end

end
