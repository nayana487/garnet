class Location < ActiveRecord::Base

  has_and_belongs_to_many :users

  def has_admin? user
    self.users.include?(user)
  end
end
