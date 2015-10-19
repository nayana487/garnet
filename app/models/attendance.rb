class Attendance < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  has_one :group, through: :event

  def date
    self.event.date.strftime("%a, %m/%d/%y")
  end

  def self.status_english num
    case num
    when nil
      "Not recorded"
    when 0
      "Absent"
    when 1
      "Tardy"
    when 2
      "Present"
    end
  end

  def status_english
    self.class.status_english(self.status)
  end
end
