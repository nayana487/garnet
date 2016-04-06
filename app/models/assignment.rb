class Assignment < ActiveRecord::Base
  belongs_to :cohort

  has_many :submissions, dependent: :destroy
  has_many :users, through: :submissions

  after_create :create_submissions
  after_initialize :set_defaults
  after_update do
    # Trigger recalculating of averages
    self.submissions.each{ |s| s.save }
  end

  attr_accessor :issues

  CATEGORIES = [
    "outcomes",
    "homework",
    "project",
    "quiz"
  ]

  def create_submissions
    self.cohort.memberships.student.active.each do |membership|
      membership.submissions.create(assignment_id: self.id, status: Submission.statuses[:unmarked])
    end
  end

  def set_defaults
    self.due_date ||= Time.now
  end

  def due_date_s
    date = read_attribute(:due_date)
    if date
      return date.strftime("%a, %m/%d/%y")
    else
      return nil
    end
  end

  def issues
    get_issues if !defined? @issues
    return @issues
  end

  def get_issues
    g = Github.new(ENV)
    repo = self.repo_url.gsub(/(https?:\/\/)?(www\.)?github\.com\//, "")
    issues = g.api.issues(repo, {state: "all"})
    @issues = issues
  end

  def issues_url users = nil
    url = "#{self.repo_url}/issues"
    if users
      url += "?q=" + users.collect{|u| "involves:#{u.username}"}.join("+")
    end
    return url
  end

end
