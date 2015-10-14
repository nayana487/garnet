# ActiveRecord::Base.logger = Logger.new(STDOUT)

Assignment.destroy_all
Attendance.destroy_all
Event.destroy_all
Group.destroy_all
Membership.destroy_all
Observation.destroy_all
Submission.destroy_all
User.destroy_all

ga_groups = {
  "wdi": {
    "dc": {
      "5": {
        "rm1": {
        },
        "rm2": {
        }
      },
      "6": {
        "rm1": {
        },
        "rm2": {
        }
      },
      "7": {
        "rm4": {
        },
        "rm5": {
        },
        "rm6": {
        }
      }
    }
  }
}

ga = Group.create(title: "ga")
ga.create_descendants(ga_groups, :title)

garoot = User.create(username: "garoot", password: "foo")
jane = User.create(username: "jane", password: "foo")
john = User.create(username: "john", password: "foo")

Group.at_path("ga").memberships.create(user_id: garoot.id, is_admin: true)
