class Submission < ActiveRecord::Base
  has_one :cohort, through: :assignment

  belongs_to :assignment, touch: true
  belongs_to :membership, touch: true
  has_one :user, through: :membership
  belongs_to :admin, class_name: "User"

  scope :due, ->    { includes(:assignment).references(:assignment).where("assignments.due_date <= ?", DateTime.now)}
  scope :active, -> { includes(:membership).references(:membership).where("memberships.status <= ?", Membership.statuses[:active])}
  scope :todo, ->   { due.unmarked.active }

  enum status: [:unmarked, :missing, :incomplete, :complete]

  after_save do
    self.membership.update_percents_of("submissions")
  end

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
    return self.assignment.repo_url.sub(/(?<=github\.com\/)[\w-]+/, self.user.username)
  end

  def get_percentage_score
    if self.assignment.base_score
      ((self.score.to_f / self.assignment.base_score) * 100).round.to_s + " %"
    else
      "N/A"
    end
  end

end
