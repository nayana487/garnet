class Event < ActiveRecord::Base
  belongs_to :group
  has_many :attendances, dependent: :destroy
  has_many :users, through: :attendances
  validates :date, presence: true
  validates :title, presence: true

  after_create :create_attendances

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
  
end
