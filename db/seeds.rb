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
        "adam":{},
        "adrian":{},
        "andy":{},
        "jesse":{},
        "matt":{},
        "robin":{},
        "erica":{},
        "john":{},
        "nick":{}
      }
    }
  }
}

ga = Group.create(title: "ga")
ga.create_descendants(ga_groups, :title)
