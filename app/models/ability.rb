class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, Assignment do |assignment|
      assignment.cohort.has_admin?(user)
    end
    can :read, Assignment

    can :manage, Submission do |submission|
      submission.cohort.has_admin?(user)
    end
    can :read, Submission do |submission|
      submission.user == user
    end

    can :manage, Event do |event|
      event.cohort.has_admin?(user)
    end
    can :read, Event

    can :manage, Attendance do |attendance|
      attendance.cohort.has_admin?(user)
    end

    can :manage, Location do |location|
      location.has_admin?(user)
    end

    can :manage, Course do |course|
      course.has_admin?(user)
    end

    can :read, Attendance do |attendance|
      attendance.user == user
    end

    can :manage, Observation do |observation|
      observation.cohort.has_admin?(user)
    end

    can :manage, Membership do |membership|
      membership.cohort.has_admin?(user)
    end

    can :list_cohort_members, Cohort do |cohort|
      user && user.is_member_of(cohort)
    end

    can :read, Membership do |membership|
      user.is_admin_of?(membership.cohort) || user == membership.user
    end

    can :see_performance, Membership do |membership|
      user.is_admin_of?(membership.cohort) || user == membership.user
    end

    can :see_observations, Membership do |membership|
      user.is_admin_of?(membership.cohort)
    end

    can :create, Cohort do |cohort|
      cohort.location.has_admin?(user) || cohort.course.has_admin?(user)
    end
    can :manage, Cohort do |cohort|
      cohort.has_admin?(user)
    end
    can :read, Cohort do |cohort|
      cohort.has_admin?(user) || cohort.students.include?(user)
    end
  end
end
