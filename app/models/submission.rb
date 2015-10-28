class Submission < ActiveRecord::Base
  has_one :group, through: :assignment
  belongs_to :assignment
  belongs_to :user
  belongs_to :admin, class_name: "User"

  before_save :set_default_value

  def set_default_value
    if !self.status
      self.status = 0
    end
  end

  def due_date
    self.assignment.due_date.strftime("%a, %m/%d/%y")
  end

  def submit_date
    self.created_at
  end

  def github_pr_submitted
    repo_url = self.assignment.repo_url
    return false if !repo_url || repo_url.strip.blank?
    issue = self.assignment.issues.select do |ish|
      ish[:user][:id] == self.user.github_id.to_i
    end
    if issue.empty?
      return nil
    else
      issue = issue[0]
      if issue[:state].downcase == "open"
        self.update!(status: 1)
      elsif issue[:state].downcase == "closed"
        self.update!(status: 2)
      end
      return issue
    end
  end

  def issues_url
    return "#{self.assignment.repo_url}/issues?q=involves:#{self.user.username}"
  end

  def self.statuses
    {
      0 => "Missing",
      1 => "Incomplete",
      2 => "Complete"
    }
  end

  def status_english
    return Submission.statuses[self.status]
  end
end
