class Group < ActiveRecord::Base
  has_many :events
  has_many :attendances, through: :events
  has_many :members_attendances, through: :users, source: :attendances

  has_many :assignments
  has_many :submissions, through: :assignments
  has_many :members_submissions, through: :users, source: :submissions

  has_many :observations
  has_many :members_observations, through: :users, source: :observations

  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  has_ancestry

  validates :title, presence: true, format: {with: /\A[a-zA-Z0-9\-]+\z/, message: "Only letters, numbers, and hyphens are allowed."}

  before_save :validate_uniqueness_of_title_among_siblings

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
    @path_string ||= self.path.collect(&:title).join("_")
  end

  def owners compact = true
    memberships = self.memberships.where(is_owner: true)
    return compact ? compact_users(memberships) : memberships
  end

  def nonowners compact = true
    memberships = self.memberships.where(is_owner: [false, nil])
    return compact ? compact_users(memberships) : memberships
  end

  def admins
    return compact_users(self.path.collect{|g| g.owners(false)})
  end

  def nonadmins
    memberships = compact_users(self.subtree.collect(&:memberships))
    return memberships - self.owners
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

  def add_owner user
    self.add_member(user, true)
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

  def is_childless?
    return self.children.count < 1
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
  def compact_users memberships
    memberships.flatten.reject(&:blank?).collect(&:user).uniq.sort_by(&:last_name)
  end

end
