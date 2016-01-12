class MoveSubmissionsAndAttendanceToMemberships < ActiveRecord::Migration
  def up
    Submission.all.each do |s|
      s.membership = Membership.find_by(user: s.user, group: s.group)
      s.save
    end
    Attendance.all.each do |a|
      a.membership = Membership.find_by(user: a.user, group: a.group)
      a.save
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
