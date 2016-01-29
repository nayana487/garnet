class Course < ActiveRecord::Base
  has_many :cohorts
  FORMATS = ["Immersive", "Course"]
  has_and_belongs_to_many :admins, class_name: "User", foreign_key: :course_id

  def has_admin? user
    self.admins.include?(user)
  end
end
