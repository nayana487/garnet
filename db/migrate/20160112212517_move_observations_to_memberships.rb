class MoveObservationsToMemberships < ActiveRecord::Migration
  def up
    add_column :observations, :membership_id, :integer, references: "memberships"

    wdi = Group.at_path("ga_wdi_dc_7")
    pmi = Group.at_path("ga_pmi_dc_1")
    Observation.all.each do |obs|
      group = Group.find(obs.group_id)
      if group == wdi || group.ancestors.include?(wdi)
        new_group = wdi
      elsif group == pmi || group.ancestors.include?(pmi)
        new_group = pmi
      elsif group == Group.at_path("ga")
        new_group = wdi
      else
        raise "Ambiguous Group Membership, #{obs.id}"
      end
      matching_membership = Membership.find_by(user_id: obs.user_id, group_id: new_group.id)
      if matching_membership
        obs.membership_id = matching_membership.id
      else
        # obs.membership_id = Membership.find_by(user_id: obs.user_id, group: Group.at_path("ga_wdi_dc_7")).id
        raise "no membership found"
      end
      obs.save!
    end

  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
