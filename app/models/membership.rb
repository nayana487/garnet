class Membership < ActiveRecord::Base
  belongs_to :group
  belongs_to :user

  validate :is_unique_in_group
  after_create :create_parent_membership, :create_child_memberships
  after_destroy :destroy_child_memberships

  def is_unique_in_group
    if self.group.memberships.where(user_id: self.user_id).count > 0
      errors[:base].push("A user may have only one membership in a given group.")
    end
  end

  def default_values
    if !self.is_admin
      self.is_admin = "false"
      self.save!
    end
  end

  def create_parent_membership
    return if !self.group.parent
    return if self.group.parent.memberships.exists?(user_id: self.user_id)
    membership = self.group.parent.memberships.new
    membership.user_id = self.user_id
    membership.is_admin = false
    membership.save! if membership.valid?
  end

  def create_child_memberships
    return if !self.is_admin
    self.group.children.each do |subgroup|
      @m = subgroup.memberships.find_by(user_id: self.user_id)
      if !@m
        @m = subgroup.memberships.new
      end
      @m.user_id = self.user_id
      @m.is_admin = true
      @m.save!
    end
  end

  def destroy_child_memberships
    self.group.children.collect{|c| c.memberships}.flatten.each do |child|
      child.destroy! if child.user_id == self.user_id
    end
  end

  def self.extract_users array
    array.collect{|m| m.user}.uniq.sort{|a,b| a.name <=> b.name}
  end

  def self.by_user memberships, skip_condition = nil
    collection = {}
    memberships.each do |membership|
      next if skip_condition && membership.send(skip_condition[0]) == skip_condition[1]
      user = membership.user
      if collection.has_key?(user.username) == false
        collection[user.username] = {user: user, memberships: []}
      end
      if !collection[user.username][:memberships].include?(membership)
        collection[user.username][:memberships].push(membership)
      end
    end
    return collection.sort_by{|username, member| member[:user].name}
  end

  def name
    self.user.username
  end

  def observed_by name, body, color
    author = User.find_by(username: name.downcase)
    self.observations.create!(author_id: author.id, body: body, status: color )
  end

  def last_observation
    self.student_observations.last
  end

  def has_descendants?
    children = self.group.children
    descendants = children.select{|c| c.memberships.where(user_id: self.user_id).count > 0}
    return (descendants.count > 0)
  end

end
