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
      "6": {
        "rm1": {},
        "rm2": {}
      },
      "7": {
        "squad-adam":{},
        "squad-adrian":{},
        "squad-andy":{},
        "squad-jesse":{},
        "squad-matt":{},
        "squad-robin":{},
        "squad-erica":{},
        "squad-john":{},
        "squad-nick":{}
      }
    }
  }
}

ga = Group.create!(title: "ga")
ga.create_descendants(ga_groups, :title)
