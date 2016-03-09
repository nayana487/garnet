class AddAveragesToMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :percent_submissions, :string
    add_column :memberships, :percent_attendances, :string
    add_column :memberships, :average_observations, :float
  end
end
