class ChangeAttendanceObservationStatuses < ActiveRecord::Migration
  def up

    class MigrationAttendance < ActiveRecord::Base
      self.table_name = :attendances
    end

    class MigrationSubmission < ActiveRecord::Base
      self.table_name = :submissions
    end

    def convert_status class_to_be_changed
      nil_attendances = class_to_be_changed.where(status:nil)
      nil_attendances.update_all(status:0)
      non_nil_attendances = class_to_be_changed.all - nil_attendances
      non_nil_attendances.update_all("set status = status + 1")
    end

    convert_status MigrationAttendance
    convert_status MigrationSubmission

    # nil_attendances = MigrationAttendance.where(status:nil)
    # nil_attendances.update_all(status:0)
    # non_nil_attendances = MigrationAttendance.all - nil_attendances
    # non_nil_attendances.update_all("set status = status + 1")
    #
    # nil_submissions = MigrationSubmission.where(status:nil)
    # nil_submissions.update_all(status:0)
    # non_nil_submissions = MigrationSubmission.all - nil_submissions
    # non_nil_submissions.update_all("set status = status + 1")

  end
end
