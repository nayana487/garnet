class Attendance < ActiveRecord::Base
  belongs_to :event, touch: true
  belongs_to :membership, touch: true
  has_one :user, through: :membership

  has_one :cohort, through: :event

  scope :due, -> { includes(:event).references(:event).where("events.occurs_at <= ?", DateTime.now)}
  scope :todo, -> { due.unmarked }
  scope :self_takeable, -> {unmarked.joins(:event).where("events.occurs_at < ? AND events.occurs_at > ?", 1.hour.from_now, 4.hours.ago)}

  enum status: [:unmarked, :absent, :tardy, :present]

  def date
    self.event.occurs_at.strftime("%a, %m/%d/%y")
  end

  def calculate_status
    now = Time.now
    event_time = self.event.occurs_at
    if now < event_time
      Attendance.statuses[:present]
    elsif (now - event_time) < 4.hours
      Attendance.statuses[:tardy]
    else
      Attendance.statuses[:absent]
    end
  end

  def self.mark_pastdue_attendances_as_missed
    na_attendances = self.unmarked.joins(:event).where("events.occurs_at < ?", Time.now.beginning_of_day)
    na_attendances.update_all(status: 1)
  end
end
