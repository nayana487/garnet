# ActiveRecord::Base.logger = Logger.new(STDOUT)
load "#{Rails.root}/db/seeds/common.rb"

# generates a random time from a start to end date, defaults to 8 month range of current time
def rand_time( from = Time.now - 4.months, to = Time.now + 4.months)
  Time.at(from + rand * (to.to_time.to_f - from.to_time.to_f))
end


ASSIGNMENT_CATEGORIES = ["outcomes", "homework", "project"]
REPO_NAMES = ["pixart_js", "wdi_radio", "puppy_db", "tunr", "trillo", "stock-tracker", "spotify-me"]
TAG_NAMES = ["Squad A", "Squad B", "Squad C", "Squad D", "Squad E", "Lightning Bears", "Fire Goldfish", "Water Monkeys"]

NUM_USERS = 100
NUM_LOCATIONS = 3
NUM_COURSES = 3
NUM_COHORTS_PER_COURSE = 4

NUM_USERS.times do |i|
  name = FFaker::Name.name
  username = name.split(" ").first.gsub(/[\'\s\.]/, "-") + i.to_s
  User.create!(name: name, username: username, email: FFaker::Internet.safe_email, password: "foo")
end

TAG_NAMES.each { |tag| Tag.create!(name: tag) }

# Creates cohorts based on course and locations
Location.all.sample(NUM_LOCATIONS).each do |loc|
  Course.all.sample(NUM_COURSES).each do |course|
    rand(NUM_COHORTS_PER_COURSE).times do |i|
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
  puts "iteration #{i} cohort #{cohort.name} stuff generating"
  students = User.all.sample(rand(5..75))
  instructors = (User.all - students).sample(rand(1..5))
  # For each cohort, adds some members and admins
  students.each_with_index do |student, i|
    cohort.add_member(student)
    membership = Membership.find_by(cohort: cohort, user: student)
    Tag.all.sample(2).each do |tag|
      Tagging.create!(membership: membership, tag: tag)
    end
  end
  instructors.each do |instructor|
    cohort.add_admin(instructor)
    membership = Membership.find_by(cohort: cohort, user: instructor)
    Tag.all.sample(2).each do |tag|
      Tagging.create!(membership: membership, tag: tag)
    end
  end
  # for each student in cohort, creates random observations
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
  # creates events for cohort, which auto generates attendance
  rand(0..30).times do |i|
    date = rand_time(cohort.start_date.to_time, cohort.end_date.to_time)
    event = cohort.events.create!(
      date: date,
      title: date.strftime("%B %d, %Y")
    )

    event.attendances.each do |attendance|
      case rand(100)
      when 0..90
        attendance.update_columns(status: 2)
      when 91..95
        attendance.update_columns(status: 1)
      when 95..98
        attendance.update_columns(status: 0)
      end
    end

  end
  # creates assignments for cohort, which auto generates submissions
  rand(0..30).times do |i|
    due_date = rand_time(cohort.start_date.to_time, cohort.end_date.to_time)
    assignment = cohort.assignments.create!(
      due_date: due_date,
      title: due_date.strftime("%B %d, %Y"),
      category: ASSIGNMENT_CATEGORIES.sample,
      repo_url: "https://github.com/ga-dc/" + REPO_NAMES.sample
    )

    assignment.submissions.each do |submission|
      case rand(100)
      when 0..90
        submission.update_columns(status: 2)
      when 91..95
        submission.update_columns(status: 1)
      when 95..98
        submission.update_columns(status: 0)
      end
    end


  end
end

# Deactivate a random number of memberships
num_to_deactivate = (Membership.where(is_admin: false).count * 0.1).to_i
Membership.order("RANDOM()").limit(num_to_deactivate).each do |m|
  m.inactive!
end
