class RemoveStudentsFromGa < ActiveRecord::Migration
  def change
    Group.at_path("ga").memberships.where(is_owner: [false, nil]).delete_all
  end
end
