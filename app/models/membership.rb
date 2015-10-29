class Membership < ActiveRecord::Base
  belongs_to :group
  belongs_to :user

  validate :is_unique_in_group, on: :create

  def to_param
    self.user.username
  end

  def is_unique_in_group
    if self.group.memberships.where(user_id: self.user_id).count > 0
      errors[:base].push("A user may have only one membership in a given group.")
    end
  end

  def make_admin_nonadmin
    if self.is_admin
      self.update(is_admin: false)
      self.save
      return false
    end
  end

  def self.extract_users array
    array.collect{|m| m.user}.uniq.sort_by(&:name)
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

  def update_ancestor_memberships
    user = self.user
    checked_so_far = []
    self.group.ancestors.each do |group|
      next if checked_so_far.include?(group.id)
      checked_so_far.push(group.id)
      next if group.has_member?(user)
      group.memberships.create!(user: user)
    end
  end

end
