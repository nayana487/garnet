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


wdi_dc_7 = Group.at_path("ga_wdi_dc_7")
wdi_dc_7.add_owner(adam)
wdi_dc_7.add_owner(jesse)
wdi_dc_7.add_owner(matt) # for attendance

wdi_dc_7.add_member(alice)
wdi_dc_7.add_member(bob)
wdi_dc_7.add_member(carol)

squad_adam = Group.at_path("ga_wdi_dc_7_squad-adam")
squad_adam.add_owner(adam, true)
squad_adam.add_member(jane)
squad_adam.add_member(john)
squad_adam.add_member(test_user)
squad_adam.assignments.create!(title: "Test Assignment1", repo_url: "http://github.com/wdidc/test_repo")

squad_matt = Group.at_path("ga_wdi_dc_7_squad-matt")
squad_matt.add_owner(matt, true)
squad_matt.add_member(test_user)
