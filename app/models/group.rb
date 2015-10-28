class Group < Tree
  has_many :events
  has_many :attendances, through: :events

  has_many :assignments
  has_many :submissions, through: :assignments

  has_many :observations

  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  belongs_to :parent, class_name: "Group"
  has_many :children, class_name: "Group", foreign_key: "parent_id"

  validates :title, presence: true, format: {with: /\A[a-zA-Z0-9\-]+\z/, message: "Only letters, numbers, and hyphens are allowed."}

  validate :validates_presence_of_parent
  before_save :validate_uniqueness_of_title_among_siblings

  def to_param
    self.path
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

  def self.at_path path
    path = path.split("_")
    group = Group.find_by(title: path[0])
    path.each_with_index do |title, i|
      next if i == 0
      group = group.children.find_by(title: path[i])
    end
    return group
  end

  def path
    @path ||= self.ancestors.collect{|g| g.title}.join("_")
  end

  def admins
    output = self.memberships.where(is_admin: true).collect{|m| m.user}.sort{|a,b| a.last_name <=> b.last_name}
    output.push(User.named("garoot"))
    output.compact
  end

  def nonadmins
    self.memberships.where(is_admin: [false, nil]).collect{|m| m.user}.sort{|a,b| a.last_name <=> b.last_name}
  end

  def subnonadmins
    self.descendants_attr("memberships").select{|m| !m.is_admin}.collect{|m| m.user}.sort{|a,b| a.last_name <=> b.last_name}
  end

  def member user
    memberships = self.memberships
    if user.class <= String
      user = User.named(user)
    end
    return memberships.find_by(user: user)
  end

  def add_member user, is_admin = false
    memberships = self.memberships
    if user.class <= String
      user = User.named(user)
    end
    return self.memberships.create!(user: user, is_admin: is_admin)
  end

  def add_admin user
    self.add_member(user, true)
  end

  def has_member? user
    self.member(user)
  end

  def is_childless?
    return self.children.count < 1
  end

end
