class Observation < ActiveRecord::Base
  belongs_to :admin, class_name: "User"
  belongs_to :membership

  has_one :group, through: :membership
  has_one :user,  through: :membership

  def self.statuses
    {
      red: 0,
      yellow: 1,
      green: 2
    }
  end
end
