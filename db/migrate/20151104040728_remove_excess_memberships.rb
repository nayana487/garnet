class RemoveExcessMemberships < ActiveRecord::Migration
  def change
    Group.at_path("ga").memberships.where(is_owner: true).delete_all
    Group.at_path("ga_wdi").memberships.delete_all
    Group.at_path("ga_wdi_dc").memberships.delete_all

    garoot = User.named("garoot")
    garoot.destroy if garoot
    Group.at_path("ga").add_owner("jshawl")
    Group.at_path("ga").add_owner("bmartinowich")
  end
end
