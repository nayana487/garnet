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

  def name
    self.user.username
  end

  def has_descendants?
    children = self.group.children
    descendants = children.select{|c| c.memberships.where(user_id: self.user_id).count > 0}
    return (descendants.count > 0)
  end

end
