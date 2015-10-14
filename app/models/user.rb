class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: true, format: {with: /[a-zA-Z0-9\-_]+/, message: "Only letters, numbers, hyphens, and underscores are allowed."}
  validates :github_id, allow_blank: true, uniqueness: true

  has_many :memberships, dependent: :destroy
  has_many :groups, through: :memberships

  has_many :observations
  has_many :admin_observations, class_name: "Observation"

  has_many :submissions
  has_many :admin_submissions, class_name: "Submission"
  has_many :assignments, through: :submissions

  has_many :attendances
  has_many :admin_attendances, class_name: "Attendance"
  has_many :events, through: :attendances

  before_save :before_save
  attr_accessor :password

  def before_save
    self.username.downcase!
    self.password_digest = User.new_password(self.password)
  end

  def to_param
    "#{self.username}"
  end

  def self.named username
    User.find_by(username: username)
  end

  def self.new_password password
    BCrypt::Password.create(password)
  end

  def password_ok? password
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def was_observed group_path, admin_username, body, status
    self.observations.create!({
      group_id: Group.at_path(group_path).id,
      admin_id: User.named(admin_username).id,
      body: body,
      status: status
    })
  end

end
