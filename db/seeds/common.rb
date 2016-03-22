DatabaseCleaner.clean_with(:truncation)

Course.create!([
  { name: 'Web Development Immersive',        short_name: 'WDI',  format: 'Immersive' },
  { name: 'User Experience Design Immersive', short_name: 'UXDI', format: 'Immersive' },
  { name: 'Product Management Immersive',     short_name: 'PMI',  format: 'Immersive' },
  { name: 'Android Development Immersive',    short_name: 'ADI',  format: 'Immersive' },
  { name: 'User Experience Design',           short_name: 'UXD',  format: 'Course' },
  { name: 'Digital Marketing',                short_name: 'DGM',  format: 'Course' },
  { name: 'Data Science',                     short_name: 'DAT',  format: 'Course' },
  { name: 'Data Analytics',                   short_name: 'ANA',  format: 'Course' },
  { name: 'iOS Mobile Development',           short_name: 'MOB',  format: 'Course' },
  { name: 'Front-End Web Development',        short_name: 'FEWD', format: 'Course' },
  { name: 'Back-End Web Development',         short_name: 'BEWD', format: 'Course' },
  { name: 'Product Management',               short_name: 'PDM',  format: 'Course' },
  { name: 'Javascript',                       short_name: 'JS',   format: 'Course' }
])

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
