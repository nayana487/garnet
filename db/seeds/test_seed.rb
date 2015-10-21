load "#{Rails.root}/db/seeds.rb"
# ActiveRecord::Base.logger = Logger.new(STDOUT)

jane = User.create(username: "jane", password: "foo")
john = User.create(username: "john", password: "foo")
alice = User.create(username: "alice", password: "foo")
bob = User.create(username: "bob", password: "foo")
carol = User.create(username: "carol", password: "foo")
adam = User.create(username: "adam", password: "foo")
jesse = User.create(username: "jesse", password: "foo")

Group.at_path("ga_wdi_dc_7").add_admin(adam)
Group.at_path("ga_wdi_dc_7").add_admin(jesse)
Group.at_path("ga_wdi_dc_7_adam").add_admin(adam)

Group.at_path("ga_wdi_dc_7_adam").add_member(jane)
Group.at_path("ga_wdi_dc_7_adam").add_member(john)
Group.at_path("ga_wdi_dc_7").add_member(alice)
Group.at_path("ga_wdi_dc_7").add_member(bob)
Group.at_path("ga_wdi_dc_7").add_member(carol)
