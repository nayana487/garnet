namespace :attendance do
  desc "Marks attendances that have been N/A for 24hrs as absent"
  task mark_absent: :environment do
    Attendance.all.each do |attendance|
      attendance.mark_na_absent_24
    end
  end
end
