class Course < ActiveRecord::Base
  has_many :cohorts
  FORMATS = ["Immersive", "Course"]
end
