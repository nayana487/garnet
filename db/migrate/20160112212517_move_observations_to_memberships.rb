class MoveObservationsToMemberships < ActiveRecord::Migration
  def up
    add_column :observations, :membership_id, :integer, references: "memberships"
    
    Observation.all.each do |obs|
      matching_membership = Membership.find_by(user: obs.user, group: obs.group)
      if matching_membership
        obs.membership = matching_membership
      else
        obs.membership = Membership.find_by(user: obs.user, group: Group.at_path("ga_wdi_dc_7"))
      end
      obs.save!
    end

  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
