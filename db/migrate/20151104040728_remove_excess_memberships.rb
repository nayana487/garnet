class RemoveExcessMemberships < ActiveRecord::Migration
  def change
    Group.at_path("ga").memberships.where(is_owner: true).delete_all
    Group.at_path("ga_wdi").memberships.delete_all
    Group.at_path("ga_wdi_dc").memberships.delete_all

    garoot = User.named("garoot")
    garoot.destroy if garoot

    # Add specific owners, need condition for env's that don't have these users (dev/test)
    Group.at_path("ga").add_owner("jshawl") if User.named("jshawl")
    Group.at_path("ga").add_owner("bmartinowich") if User.named("bmartinowich")
  end
end
