class Observation < ActiveRecord::Base
  belongs_to :group
  belongs_to :user
  belongs_to :membership
  belongs_to :admin, class_name: "User"

  def self.statuses
    {
      red: 0,
      yellow: 1,
      green: 2
    }
  end
end
