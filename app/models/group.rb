class Group < ActiveRecord::Base
  has_many :events
  has_many :attendances, through: :events

  has_many :assignments
  has_many :submissions, through: :assignments

  has_many :observations

  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  has_ancestry

  validates :title, presence: true, format: {with: /\A[a-zA-Z0-9\-]+\z/, message: "Only letters, numbers, and hyphens are allowed."}

  before_save :validate_uniqueness_of_title_among_siblings

  def paths_in_tree
    paths = {}
    self.ancestors.each{|g| paths[g.id] = g.path_string }
    self.subtree.each{|g| paths[g.id] = g.path_string }
    return paths
  end

  def to_param
    self.path_string
  end

  def validates_presence_of_parent
    if self.class.all.count > 0 && !self.parent && Group.first.id != self.id
      errors[:base].push("Each group has to have a parent group.")
    end
  end

  def validate_uniqueness_of_title_among_siblings
    return if !self.parent
    if self.parent.children.exists?(title: self.title)
      errors.add(:title, "must be unique among this group's siblings.")
    end
  end

  def self.at_path path_string
    return nil unless path_string
    titles = path_string.split("_")
    group = Group.find_by(title: titles.first)
    return false if !group
    titles.each_with_index do |title, i|
      next if i == 0
      group = group.children.find_by(title: title)
    end
    return group
  end

  def path_string
    @path_string ||= self.path.map(&:title).join("_")
  end

  def member user
    if user.class <= String
      user = User.named(user)
    end
    self.memberships.find_by(user: user)
  end

  def add_member user, is_owner = false
    if user.class <= String
      user = User.named(user)
    end
    self.memberships.create!(user: user, is_owner: is_owner)
  end

  def add_owner user, is_priority = false
    membership = self.add_member(user, true)
    membership.update!(is_priority: is_priority)
  end

  def has_member? user
    self.member(user)
  end

  def has_admin? user
    self.admins.include?(user)
  end

  def has_priority? user
    self.memberships.exists?(user: user, is_priority: true)
  end

  def owners
    @owners ||= User.joins(:memberships).where(memberships: {group: self, is_owner: true}).sort_by(&:last_name).uniq
  end

  def nonowners
    @nonowners ||= User.joins(:memberships).where(memberships: {group: self, is_owner: [false, nil]}).sort_by(&:last_name).uniq
  end

  def admins
    @admins ||= User.joins(:memberships).where(memberships: {group_id: self.path_ids, is_owner: true}).uniq
  end

  def nonadmins
    @nonadmins ||= (User.joins(:memberships).where(memberships: {group_id: self.subtree_ids}).where.not( id: self.owners.map(&:id) )).uniq.sort_by(&:last_name)
  end

  def members_assignments
    Assignment.joins(submissions: :user).where(in_subtree, submissions: in_nonadmins).uniq.order(:due_date)
  end

  def members_submissions
    Submission.joins(:assignment, :user).where(in_nonadmins, assignments: in_subtree).uniq
  end

  def members_events
    Event.joins(attendances: :user).where(in_subtree, attendances: in_nonadmins).uniq.order(:date)
  end

  def members_attendances
    Attendance.joins(:event, :user).where(in_nonadmins, events: in_subtree).uniq
  end

  def members_observations
    Observation.joins(:user).where(in_nonadmins, in_subtree).uniq
  end

  def create_descendants hash, name
    hash.each do |key, subtree|
      child = self.children.new
      child.send("#{name}=", key)
      child.save!
      child.create_descendants(subtree, name)
    end
  end

  def create_descendants hash, name
    hash.each do |key, subtree|
      child = self.children.new
      child.send("#{name}=", key)
      child.save!
      child.create_descendants(subtree, name)
    end
  end

  private
  def in_nonadmins
    {user_id: self.nonadmins.map(&:id)}
  end

  def in_subtree
    {group_id: self.subtree_ids}
  end

end
