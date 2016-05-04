class AddTimeZoneToCohorts < ActiveRecord::Migration
  def change
    add_column :cohorts, :time_zone, :string, default: "UTC"
  end
end
