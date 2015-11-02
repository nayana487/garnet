class ChangeMembershipsIsAdminToIsOwner < ActiveRecord::Migration
  def change
    rename_column :memberships, :is_admin, :is_owner
  end
end
