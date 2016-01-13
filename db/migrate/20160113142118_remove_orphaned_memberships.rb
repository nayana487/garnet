class RemoveOrphanedMemberships < ActiveRecord::Migration
  def up
    Membership.where(cohort: nil).destroy_all
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
