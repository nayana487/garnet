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

  def status_english
    case self.status
    when 0
      "Absent"
    when 1
      "Tardy"
    when 2
      "Present"
    end
  end
end
