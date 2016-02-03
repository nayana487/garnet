class AddApiTokenToCohort < ActiveRecord::Migration
  def change
    add_column :cohorts, :api_token, :string
  end
end
