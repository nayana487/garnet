class UpdateAttendancesColumns < ActiveRecord::Migration
  def change
    remove_column :attendances, :required, :boolean
    remove_column :attendances, :admin_id, :integer
    add_column :attendances, :self_taken, :boolean, default: false
    add_column :attendances, :checked_in_at, :datetime
    add_column :attendances, :ip_address, :string
  end
end
