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
    assoc = self.send(association).due

    marked_by_status = assoc.where(status:status).length
    total_marked     = assoc.where.not(status: assoc.statuses[:unmarked]).length

    return nil if total_marked == 0
    ((marked_by_status.to_f / total_marked.to_f) * 100).round(0)
  end

  def last_observation
    time = self.observations.maximum(:created_at)
    if time
      return time.strftime("%y/%m/%d")
    else
      return "N/A"
    end
  end

  def average_observations
    average = self.observations.average(:status).to_f.round(2)
    self.observations.any? ? average : nil
  end

  def self.filter_by_tag tag
    tags = URI.decode(tag).split("|")
    joins(:tags).where("tags.name IN (?)", tags).uniq
  end

  def as_json(options={})
    super.as_json(options).merge({
      name: self.user.name
    })
  end

end
