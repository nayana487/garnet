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

  validates :title, presence: true, format: {with: /[a-zA-Z0-9\-]+/, message: "Only letters, numbers, and hyphens are allowed."}
  validate :has_parent_and_unique_name_among_siblings
  before_save :update_path
  after_save :update_child_paths

  def to_param
    self.path
  end

  def has_parent_and_unique_name_among_siblings
    if !self.parent
      if self.class.all.count > 0
        errors[:base].push("Each Group has to have a parent group.")
      end
    else
      sibling = self.parent.children.find_by(title: self.title)
      if sibling && sibling.id != self.id
        errors.add(:title, "must be unique among this group's siblings.")
      end
    end
  end

  def self.at_path path
    Group.find_by(path: path)
  end

  def update_path
    titles = self.ancestors([]).collect{|g| g.title}
    titles.push(self.title)
    self.path = titles.join("_")
  end

  def update_child_paths
    self.children.each do |group|
      group.update_path
      group.save!
    end
  end

  def owners
    self.ancestors_attr("memberships").select{|m| m.is_admin && m.user.username != "garoot"}.collect{|m| m.user}.uniq
  end

  def admins
    self.memberships.where(is_admin: true).collect{|m| m.user}
  end

  def nonadmins
    self.memberships.where(is_admin: false).collect{|m| m.user}
  end

  def subnonadmins
    self.descendants_attr("memberships").select{|m| !m.is_admin}.collect{|m| m.user}.uniq
  end

  def bulk_create_memberships array, is_admin
    array.each do |child|
      user = User.find_by(username: child[0].downcase)
      if !user
        user = User.create!(username: child[0], name: child.join(" "), password: child[1].downcase)
      end
      self.memberships.create(user_id: user.id, is_admin: is_admin)
    end
  end

end
