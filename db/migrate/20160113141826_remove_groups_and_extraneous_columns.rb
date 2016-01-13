class RemoveGroupsAndExtraneousColumns < ActiveRecord::Migration
  def change
    remove_column :assignments, :group_id
    remove_column :attendances, :user_id
    remove_column :events, :group_id
    remove_column :memberships, :group_id
    remove_column :memberships, :is_priority
    remove_column :observations, :user_id
    remove_column :observations, :group_id
    remove_column :submissions, :user_id
    drop_table :groups
  end
end
