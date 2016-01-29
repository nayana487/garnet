class Location < ActiveRecord::Base
  has_many :cohorts
  has_and_belongs_to_many :admins, class_name: "User", foreign_key: :location_id

  def has_admin? user
    self.admins.include?(user)
  end
end
