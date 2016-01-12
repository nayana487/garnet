class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :memberships, through: :taggings
end
