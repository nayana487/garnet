class Observation < ActiveRecord::Base
  belongs_to :admin, class_name: "User"
  belongs_to :membership, touch: true

  has_one :cohort, through: :membership
  has_one :user,  through: :membership

  enum status: [:red, :yellow, :green]

end
