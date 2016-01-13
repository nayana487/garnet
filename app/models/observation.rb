class Observation < ActiveRecord::Base
  belongs_to :admin, class_name: "User"
  belongs_to :membership

  has_one :cohort, through: :membership
  has_one :user,  through: :membership

  # TODO: should be an enum -ab
  def self.statuses
    {
      red: 0,
      yellow: 1,
      green: 2
    }
  end
end
