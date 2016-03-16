class AddAnotherColumnToAssignment < ActiveRecord::Migration
  def change
    add_column :assignments, :public, :boolean
  end
end
