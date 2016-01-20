class PreventIsOwnerFromBeginNil < ActiveRecord::Migration
  def change
    Membership.where(is_owner: nil).update_all(is_owner: false)

    # Change the column to not allow null
    change_column :memberships, :is_owner, :boolean, :null => false
  end
end
