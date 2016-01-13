class Submission < ActiveRecord::Base
  has_one :group, through: :assignment
  has_one :cohort, through: :assignment

  belongs_to :assignment
  belongs_to :membership
  has_one :user, through: :membership
  belongs_to :admin, class_name: "User"

  def due_date
    self.assignment.due_date.strftime("%a, %m/%d/%y")
  end

  def submit_date
    self.created_at
  end

  def issues_url
    return "#{self.assignment.repo_url}/issues?q=involves:#{self.user.username}"
  end

  def fork_url
    return self.assignment.repo_url.sub(/ga-dc/, self.user.username)
  end

  def self.statuses
    {
      nil => "n/a",
      0 => "Missing",
      1 => "Incomplete",
      2 => "Complete"
    }
  end

  def status_english
    return Submission.statuses[self.status]
  end
end
