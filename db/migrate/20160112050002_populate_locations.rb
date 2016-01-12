class PopulateLocations < ActiveRecord::Migration
  def up
    Location.create!([
      { name: 'Atlanta',        short_name: 'ATL' },
      { name: 'Austin',         short_name: 'ATX' },
      { name: 'Boston',         short_name: 'BOS' },
      { name: 'Chicago',        short_name: 'CHI' },
      { name: 'Denver',         short_name: 'DEN' },
      { name: 'Hong Kong',      short_name: 'HK' },
      { name: 'London',         short_name: 'LON' },
      { name: 'Los Angeles',    short_name: 'LA' },
      { name: 'Melbourne',      short_name: 'MEL' },
      { name: 'New York',       short_name: 'NYC' },
      { name: 'San Francisco',  short_name: 'SF' },
      { name: 'Seattle',        short_name: 'SEA' },
      { name: 'Singapore',      short_name: 'SGP' },
      { name: 'Sydney',         short_name: 'SYD' },
      { name: 'Washington, DC', short_name: 'DC' }
    ])
  end

  def down
    Location.destroy_all
  end
end
