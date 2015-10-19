class RemovePathFromGroups < ActiveRecord::Migration
  def change
    remove_column :groups, :path, :string
  end
end
