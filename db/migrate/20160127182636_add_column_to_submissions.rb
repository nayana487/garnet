class AddColumnToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :score, :integer 
  end
end
