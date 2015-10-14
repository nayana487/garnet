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
<<<<<<< HEAD
  before_create :has_parent
  before_save :has_unique_title_among_siblings, :update_path
=======
  validate :has_parent
  before_create :update_path
  before_save :has_unique_title_among_siblings
>>>>>>> autocreation of memberships
  after_save :update_child_paths, :update_child_members

  def to_param
    self.path
  end

  def has_parent
<<<<<<< HEAD
    if self.class.all.count > 1 && !self.parent
      raise "Each group has to have a parent group."
=======
    if self.class.all.count > 0 && !self.parent
      errors[:base].push("Each group has to have a parent group.")
>>>>>>> autocreation of memberships
    end
  end

  def has_unique_title_among_siblings
    return if !self.parent
    if self.parent.children.exists?(title: self.title)
      errors.add(:title, "must be unique among this group's siblings.")
    end
  end

  def self.at_path path
    Group.find_by(path: path)
  end

  def update_path
    if self.parent
      titles = self.ancestors([]).collect{|g| g.title}
    else
      titles = []
    end
    titles.push(self.title)
    self.path = titles.join("_")
  end

  def update_child_paths
    self.children.each do |group|
<<<<<<< HEAD
      group.save!
=======
      group.update_path
>>>>>>> autocreation of memberships
    end
  end

  def update_child_members
    return if !self.parent
    self.parent.memberships.where(is_admin: true).each do |membership|
      self.memberships.create(user_id: membership.user.id, is_admin: true)
    end
  end

  def admins
    self.memberships.where(is_admin: true).collect{|m| m.user}
  end

  def nonadmins
    self.memberships.where(is_admin: [false, nil]).collect{|m| m.user}
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
