load "#{Rails.root}/db/seeds.rb"
# ActiveRecord::Base.logger = Logger.new(STDOUT)

test_user = User.create(username: "TestWDIDCStudent", password: 'foo', github_id: 13137527)
jane = User.create(username: "jane", password: "foo")
john = User.create(username: "john", password: "foo")
alice = User.create(username: "alice", password: "foo")
bob = User.create(username: "bob", password: "foo")
carol = User.create(username: "carol", password: "foo")
adam = User.create(username: "adam", password: "foo")
jesse = User.create(username: "jesse", password: "foo")
matt = User.create(username: "mattscilipoti", password: "foo", github_id: '31929')

Group.at_path("ga_wdi_dc_7").add_owner(adam)
Group.at_path("ga_wdi_dc_7").add_owner(jesse)
Group.at_path("ga_wdi_dc_7_squad-adam").add_owner(adam, true)
Group.at_path("ga_wdi_dc_7_squad-adam").add_owner(matt, true)

Group.at_path("ga_wdi_dc_7_squad-adam").add_member(jane)
Group.at_path("ga_wdi_dc_7_squad-adam").add_member(john)
Group.at_path("ga_wdi_dc_7_squad-adam").add_member(test_user)
Group.at_path("ga_wdi_dc_7").add_member(alice)
Group.at_path("ga_wdi_dc_7").add_member(bob)
Group.at_path("ga_wdi_dc_7").add_member(carol)

squad_adam = Group.at_path("ga_wdi_dc_7_squad-adam")
squad_adam.assignments.create!(title: "Test Assignment1", repo_url: "http://github.com/wdidc/test_repo")
