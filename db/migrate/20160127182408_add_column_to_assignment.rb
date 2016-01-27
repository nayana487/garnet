class AddColumnToAssignment < ActiveRecord::Migration
  def change
    add_column :assignments, :base_score, :integer 
  end
end
