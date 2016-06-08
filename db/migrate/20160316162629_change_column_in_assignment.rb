class ChangeColumnInAssignment < ActiveRecord::Migration
  def change
    change_column :assignments, :public, :boolean, :default => false
  end
end
