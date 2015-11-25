class RemoveStudentsFromGa < ActiveRecord::Migration
  def change
    @group = Group.at_path("ga")
    return if !@group
    @group.memberships.where(is_owner: [false, nil]).delete_all
  end
end
