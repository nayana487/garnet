# ActiveRecord::Base.logger = Logger.new(STDOUT)
puts "seeds file running"
Assignment.destroy_all
puts "assignments destroyed"
Attendance.destroy_all
Event.destroy_all
Cohort.destroy_all
Membership.destroy_all
Observation.destroy_all
Submission.destroy_all
User.destroy_all
Location.destroy_all
Course.destroy_all
Tagging.destroy_all
Tag.destroy_all

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

def rand_time( from = Time.now - 4.months, to = Time.now + 4.months)
  Time.at(from + rand * (to.to_time.to_f - from.to_time.to_f))
end


NUM_USERS = 100
ASSIGNMENT_CATEGORIES = ["outcomes", "homework", "project"]
REPO_NAMES = ["pixart_js", "wdi_radio", "puppy_db", "tunr", "trillo", "stock-tracker", "spotify-me"]
NUM_USERS.times do |i|
  name = FFaker::Name.name
  username = name.split(" ").first.gsub(/[\'\s\.]/, "-") + i.to_s
  User.create!(name: name, username: username, email: FFaker::Internet.safe_email, password: "foo")
end

Location.all.sample(3).each do |loc|
  puts loc
  Course.all.sample(3).each do |course|
    rand(4).times do |i|
      start_date = rand_time
      Cohort.create(name: "#{loc.short_name} #{course.short_name} #{i}",
                    start_date: start_date,
                    end_date: start_date + 3.months,
                    location: loc,
                    course: course
      )

    end
  end
end

Cohort.all.each_with_index do |cohort, i|
  puts "iteration #{i} cohort #{cohort} stuff generating"
  students = User.all.sample(rand(5..75))
  instructors = (User.all - students).sample(rand(1..5))
  students.each do |student|
    cohort.add_member(student)
  end
  instructors.each do |instructor|
    cohort.add_admin(instructor)
  end
  students.each do |student|
    membership = Membership.find_by(cohort: cohort, user: student)
    inst_memberships = Membership.where(cohort: cohort, user: instructors)
    rand(0..20).times do |i|
      Observation.create!(
        membership: membership,
        admin: inst_memberships.sample.user,
        body: FFaker::Lorem.paragraph,
        status: rand(0..2)
      )
    end
  end
  rand(0..30).times do |i|
    date = rand_time(cohort.start_date.to_time, cohort.end_date.to_time)
    cohort.events.create!(
      date: date,
      title: date.strftime("%B %d, %Y")
    )
  end
  rand(0..30).times do |i|
    due_date = rand_time(cohort.start_date.to_time, cohort.end_date.to_time)
    cohort.assignments.create!(
      due_date: due_date,
      title: due_date.strftime("%B %d, %Y"),
      category: ASSIGNMENT_CATEGORIES.sample,
      repo_url: "https://github.com/ga-dc/" + REPO_NAMES.sample
    )
  end
end
