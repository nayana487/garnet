class Cohort < ActiveRecord::Base
  has_many :events
  has_many :attendances, through: :events

  has_many :assignments
  has_many :submissions, through: :assignments

  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  belongs_to :course
  belongs_to :location
end
