class Attendance < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  has_one :group, through: :event

  before_save :set_default_value

  def set_default_value
    if !self.status
      self.status = 0
    end
  end

  def date
    self.event.date.strftime("%a, %m/%d/%y")
  end

  def self.statuses
    {
      0 => "Absent",
      1 => "Tardy",
      2 => "Present"
    }
  end

  def status_english
    return Submission.statuses[self.status]
  end
end
