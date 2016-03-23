class AddOutcomesIdToMembership < ActiveRecord::Migration
  def change
    add_column :memberships, :outcomes_id, :integer
  end
end
