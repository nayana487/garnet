class AddInviteCodeToCohorts < ActiveRecord::Migration
  def change
    add_column :cohorts, :invite_code, :string
  end
end
