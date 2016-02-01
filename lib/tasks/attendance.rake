namespace :attendance do
  desc "Marks attendances that have been N/A for 24hrs as absent"
  task mark_absent: :environment do
    Attendance.mark_pastdue_attendances_as_missed
  end
end
