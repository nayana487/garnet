class Tagging < ActiveRecord::Base
  belongs_to :membership
  belongs_to :tag
end
