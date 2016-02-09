class Submission < ActiveRecord::Base
  has_one :cohort, through: :assignment

  belongs_to :assignment, touch: true
  belongs_to :membership, touch: true
  has_one :user, through: :membership
  belongs_to :admin, class_name: "User"

  scope :unmarked, -> { where(status: 0) }
  scope :missing, -> { where(status: 1) }
  scope :incomplete, -> { where(status: 2) }
  scope :complete, -> { where(status: 3) }
  scope :due, -> { includes(:assignment).references(:assignment).where("assignments.due_date <= ?", DateTime.now)}
  scope :todo, -> { due.unmarked }

  enum status: [:"n/a", :missing, :incomplete, :complete]

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

  def get_percentage_score
    if self.assignment.base_score
      ((self.score.to_f / self.assignment.base_score) * 100).round.to_s + " %"
    else
      "No Grade"
    end
  end

end
