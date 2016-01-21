class PopulateCourses < ActiveRecord::Migration
  def up
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
    end

    def down
      Course.destroy_all
    end
  end
