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

  def get_issues token
    g = Github.new(nil, token)
    org_slash_repo = self.repo_url.gsub(/https:\/\/github\.com\//, "")
    @issues = g.issues( org_slash_repo )
  end

  def categories
    [
      "outcomes",
      "homework",
      "project"
    ]
  end

end
