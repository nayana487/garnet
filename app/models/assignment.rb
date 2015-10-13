class Assignment < ActiveRecord::Base
  has_many :submissions
  belongs_to :group

  after_create :create_submissions
  after_initialize :set_defaults

  def create_submissions
    group = Group.find(self.group_id)
    students = group.memberships.where(is_admin: false)
    students.each do |student|
      student.submissions.create(assignment_id: self.id, status: "incomplete")
    end

  end

  def set_defaults
    self.due_date ||= Time.now
  end

  def summary_info
   summary_items = [category]
   summary_items << "due: #{due_date.strftime("%A, %B %e, %Y at %r")}" if due_date?
   summary_items
 end

end
