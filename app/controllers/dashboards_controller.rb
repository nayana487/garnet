class DashboardsController < ApplicationController
  def to_do
    redirect_to current_user unless current_user.is_admin_of_anything?

    active_cohorts = current_user.adminned_cohorts.active
    @inactive_cohorts = current_user.adminned_cohorts.inactive

    @todo_info = {}
    active_cohorts.each do |cohort|
      @todo_info[cohort] = {}
      @todo_info[cohort][:submissions] = current_user.get_todo(Submission, cohort)
      @todo_info[cohort][:attendances] = current_user.get_todo(Attendance, cohort)
    end

    active_cohort_ids = active_cohorts.map{|cohort| cohort.id}
    @observations = Observation.joins(:membership).where("memberships.cohort_id IN (?)", active_cohort_ids).order(created_at: :desc).limit(10)
  end
end
