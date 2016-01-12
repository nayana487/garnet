class Membership < ActiveRecord::Base
  enum status: [ :active, :inactive ]

  belongs_to :group
  belongs_to :cohort
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

  # TODO: This isn't called anywhere -AB
  def make_admin_nonadmin
    if self.is_owner
      self.update(is_owner: false)
      self.save
      return false
    end
  end

  def name
    self.user.username
  end

  # TODO: This isn't called anywhere -AB
  def has_descendants?
    children = self.group.children
    descendants = children.select{|c| c.memberships.where(user_id: self.user_id).count > 0}
    return (descendants.count > 0)
  end

  def toggle_active!
    self.active? ? self.inactive! : self.active!
  end

end
