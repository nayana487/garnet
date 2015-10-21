class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, Assignment do |assignment|
      assignment.group.has_admin?(user)
    end
    can :read, Assignment

    can :manage, Submission do |submission|
      submission.group.has_admin?(user)
    end
    can :read, Submission do |submission|
      submission.user == user
    end

    can :manage, Event do |event|
      event.group.has_admin?(user)
    end
    can :read, Event

    can :manage, Attendance do |attendance|
      attendance.group.has_admin?(user)
    end
    can :read, Attendance do |attendance|
      attendance.user == user
    end

    can :manage, Observation do |observation|
      observation.group.has_admin?(user)
    end

    can :manage, Membership do |membership|
      membership.group.has_admin?(user)
    end
    cannot :update, Membership do |membership|
      membership.group.has_admin?(user)
    end
  end
end
