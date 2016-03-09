class AddLocationCourseNumberToCohorts < ActiveRecord::Migration
  def change
    add_column :cohorts, :number_at_location, :integer
    Cohort.all.each do |cohort|
      cohort.number_at_location = cohort.name.match(/(?<=\s)[0-9]+$/).to_s.to_i
      cohort.save!
    end
  end
end
