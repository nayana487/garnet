class Event < ActiveRecord::Base
  belongs_to :cohort

  has_many :attendances, dependent: :destroy
  has_many :users, through: :attendances

  scope :on_date, ->(date) { where("occurs_at >= ? and occurs_at <= ?", date.beginning_of_day, date.end_of_day)}

  validates :occurs_at,
    presence: true,
    uniqueness: {
      scope: :cohort,
      message: "should be unique for this cohort"
    }
  validates :title, presence: true
  validate :avoid_duplicate_events, on: :create

  after_create :create_attendances

  def self.duplicate_date_delta
    1.second
  end


  def create_attendances
    # TODO use named scope on cohort
    self.cohort.memberships.where(is_admin: false).each do |membership|
      membership.attendances.create!(event_id: self.id)
    end
  end

  def occurs_at_s
    event_time = read_attribute(:occurs_at)
    if event_time
      return event_time.strftime("%a, %m/%d/%y")
    else
      return nil
    end
  end

  # returns events that occur close to this event's date
  def nigh_events(delta = Event.duplicate_date_delta)
    cohort.events.where("occurs_at > ? AND occurs_at < ?", occurs_at - delta, occurs_at + delta)
  end

  private

  # WORKAROUND: to avoid duplicate attendance events
  # mms: this is rather heavy heanded.
  # TODO: should be warning?  http://stackoverflow.com/questions/24628628/efficient-way-to-report-record-validation-warnings-as-well-as-errors
  def avoid_duplicate_events
    if self.nigh_events.exists?
      errors.add(:occurs_at, "Event (for #{occurs_at}, #{title}) occurs too close to other events.")
    end
  end
end
