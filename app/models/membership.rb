class Membership < ActiveRecord::Base
  include ModelHelpers
  enum status: [ :active, :inactive ]

  belongs_to :cohort
  has_many :taggings
  has_many :tags, through: :taggings

  belongs_to :user
  # allows membership to access the associated user's name
  delegate :name, to: :user

  has_many :taggings
  has_many :tags, through: :taggings

  has_many :observations
  has_many :attendances
  serialize :percent_attendances, JSON
  has_many :submissions
  serialize :percent_submissions, JSON

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
  def toggle_active!
    self.active? ? self.inactive! : self.active!
  end

  def toggle_admin!
    self.update_attribute(:is_admin, !self.is_admin)
  end

  def percent_from_status( association, status)
    percents = (self.send("percent_#{association}") || update_percents_of(association))
    return percents[status.to_s]
  end

  def update_percents_of klass
    percents_json     = {}
    klass             = class_from_string(klass)
    # = Submission
    klass_plural_name = class_plural_name(klass)
    # = submissions
    related_records   = self.send(klass_plural_name).due
    # = self.submissions.due
    unmarked_records  = related_records.where.not(status: klass.statuses[:unmarked])
    klass.statuses.each do |status_name, status|
      # Submission.statuses.each do...
      if unmarked_records.length > 0
        percent = (related_records.where(status: status).count / unmarked_records.count.to_f)
      else
        percent = 0
      end
      percents_json[status_name] = (percent * 100).round(0)
    end
    self.update!(:"percent_#{klass_plural_name}" => percents_json)
    # percent_submissions: {missing: 10, incomplete: 33, complete: 57}
    return percents_json
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
    return (self.read_attribute("average_observations") || update_average_observations)
  end

  def update_average_observations
    average = self.observations.where.not(status:3).average(:status).to_f.round(2)
    self.update!(average_observations: self.observations.any? ? average : nil)
    return average
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
