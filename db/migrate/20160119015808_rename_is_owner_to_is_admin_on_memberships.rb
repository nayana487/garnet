class RenameIsOwnerToIsAdminOnMemberships < ActiveRecord::Migration
  def change
    rename_column :memberships, :is_owner, :is_admin
  end
end
