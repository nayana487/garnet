class RenameEventDateToOccurredAt < ActiveRecord::Migration
  def change
    rename_column :events, :date, :occurred_at
  end
end
