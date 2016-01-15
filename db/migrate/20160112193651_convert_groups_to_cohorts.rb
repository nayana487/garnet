class ConvertGroupsToCohorts < ActiveRecord::Migration
  def up
    add_column :assignments, :cohort_id, :integer, references: "cohorts"
    add_column :events, :cohort_id, :integer, references: "cohorts"
    add_column :memberships, :cohort_id, :integer, references: "cohorts"

    wdi_group = Group.at_path("ga_wdi_dc_7")
    if wdi_group
      wdi_cohort = Cohort.create!(name: "DC WDI7",
                                  start_date: Date.parse("2015-10-12"),
                                  end_date: Date.parse("2016-01-15"),
                                  course: Course.find_by(short_name: "WDI"),
                                  location: Location.find_by(short_name: "DC"))

      wdi_cohort.memberships = wdi_group.memberships
      wdi_cohort.assignments = wdi_group.assignments
      wdi_cohort.events = wdi_group.events
      wdi_cohort.save!
    end

    pmi_group = Group.at_path("ga_pmi_dc_1")
    if pmi_group
      pmi_cohort = Cohort.create!(name: "DC PMI1",
                                  start_date: Date.parse("2015-11-09"),
                                  end_date: Date.parse("2016-01-29"),
                                  course: Course.find_by(short_name: "PMI"),
                                  location: Location.find_by(short_name: "DC"))


      pmi_cohort.memberships = pmi_group.memberships
      pmi_cohort.assignments = pmi_group.assignments
      pmi_cohort.events = pmi_group.events
      wdi_cohort.save!
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
