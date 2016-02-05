class ChangeAttendanceObservationStatuses < ActiveRecord::Migration

  class MigrationAttendance < ActiveRecord::Base
    self.table_name = :attendances
  end

  class MigrationSubmission < ActiveRecord::Base
    self.table_name = :submissions
  end

  def convert_status_to_ar_enums class_to_be_changed
    nil_status_instances = class_to_be_changed.where(status:nil)
    nil_status_instances.update_all(status:0)
    non_nil_status_instances = class_to_be_changed.where.not(status:nil)
    non_nil_status_instances.update_all("status = status + 1")
  end

  def convert_status_to_class_methods class_to_be_changed
    zero_status_instances = class_to_be_changed.where(status:0)
    zero_status_instances.update_all(status:nil)
    non_zero_status_instances = class_to_be_changed.where.not(status:0)
    non_zero_status_instances.update_all("status = status - 1")
  end

  def up
    convert_status_to_ar_enums MigrationAttendance
    convert_status_to_ar_enums MigrationSubmission
  end

  def down
    convert_status_to_class_methods MigrationAttendance
    convert_status_to_class_methods MigrationSubmission
  end

end
