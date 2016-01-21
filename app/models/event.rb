class Event < ActiveRecord::Base
  belongs_to :group
  belongs_to :cohort

  has_many :attendances, dependent: :destroy
  has_many :users, through: :attendances

  validate :avoid_duplicate_events, on: :create
  validates :date,
    presence: true,
    uniqueness: {
      scope: :group,
      message: "should be unique for this group"
    }
  validates :title, presence: true

  after_create :create_attendances


  def self.duplicate_date_delta
    5.minutes
  end


  def create_attendances
    self.group.nonadmins.each do |user|
      user.attendances.create(event_id: self.id, required: self.required?)
    end
  end

  def date_s
    date = read_attribute(:date)
    if date
      return date.strftime("%a, %m/%d/%y")
    else
      return nil
    end
  end

  # returns events that occur close to this event's date
  def nigh_events(delta = Event.duplicate_date_delta)
    group.events.where("date > ? AND date < ?", date - delta, date + delta)
  end

  private

  # WORKAROUND: to avoid duplicate attendance events
  # mms: this is rather heavy heanded.
  # TODO: should be warning?  http://stackoverflow.com/questions/24628628/efficient-way-to-report-record-validation-warnings-as-well-as-errors
  def avoid_duplicate_events
    if self.nigh_events.exists?
      errors.add(:date, "Event (for #{date}, #{title}) occurs too close to other events.")
    end
  end
end
