class AddStatusToMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :status, :integer, default: 0
  end
end
