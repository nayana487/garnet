class Assignment < ActiveRecord::Base
  belongs_to :group
  has_many :submissions, dependent: :destroy
  has_many :users, through: :submissions

  after_create :create_submissions
  after_initialize :set_defaults

  attr_accessor :issues

  def create_submissions
    self.group.nonadmins.each do |user|
      user.submissions.create(assignment_id: self.id)
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

  def categories
    [
      "outcomes",
      "homework",
      "project",
      "quiz"
    ]
  end

  def api_repo_issues_url
    url = self.repo_url.gsub("https://github.com/","https://api.github.com/repos/")
    url += "/issues?state=all"
  end

  def issues_url users = nil
    url = "#{self.repo_url}/issues"
    if users
      url += "?q=" + users.collect{|u| "involves:#{u.username}"}.join("+")
    end
    return url
  end

end
