class AddWhitelistIpToCohorts < ActiveRecord::Migration
  def change
    add_column :cohorts, :whitelist_ip, :string
  end
end
