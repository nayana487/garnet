class RemoveExcessMemberships < ActiveRecord::Migration
  def change
    ["ga", "ga_wdi", "ga_wdi_dc"].each do |path|
      group = Group.at_path(path)
      next if !group
      memberships = group.memberships
      if path == "ga"
        memberships.where(is_owner: true).delete_all
        # Add specific owners, need condition for env's that don't have these users (dev/test)
        group.add_owner("jshawl") if User.named("jshawl")
        group.add_owner("bmartinowich") if User.named("bmartinowich")
      else
        memberships.delete_all
      end
    end

    garoot = User.named("garoot")
    garoot.destroy if garoot
  end
end
