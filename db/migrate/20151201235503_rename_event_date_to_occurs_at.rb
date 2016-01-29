class RenameEventDateToOccursAt < ActiveRecord::Migration
  def change
    rename_column :events, :date, :occurs_at
  end
end
