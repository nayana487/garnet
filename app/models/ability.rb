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
    can :read, Attendance do |attendance|
      attendance.user == user
    end

    can :manage, Observation do |observation|
      observation.cohort.has_admin?(user)
    end

    can :manage, Membership do |membership|
      membership.cohort.has_admin?(user)
    end
    can :read, Membership
    can :see_performance, Membership do |membership|
      user.is_admin_of?(membership.cohort) || user == membership.user
    end

    can :create, Cohort do |cohort|
      cohort.parent.has_admin?(user)
    end
    can :manage, Cohort do |cohort|
      cohort.has_admin?(user)
    end
    can :read, Cohort do |cohort|
      cohort.has_admin?(user) || cohort.students.include?(user)
    end
  end
end
