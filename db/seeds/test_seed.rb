load "#{Rails.root}/db/seeds.rb"
# ActiveRecord::Base.logger = Logger.new(STDOUT)

test_user = FactoryGirl.create(:user, username: "TestWDIDCStudent", github_id: 13137527)
jane      = FactoryGirl.create(:user, username: "jane")
john      = FactoryGirl.create(:user, username: "john")
alice     = FactoryGirl.create(:user, username: "alice")
bob       = FactoryGirl.create(:user, username: "bob")
carol     = FactoryGirl.create(:user, username: "carol")
adam      = FactoryGirl.create(:user, username: "adam", password: "foo")
jesse     = FactoryGirl.create(:user, username: "jshawl", github_id:3824954)
matt      = FactoryGirl.create(:user, username: "mattscilipoti", github_id: '31929')

dc = Location.find_by(short_name: "DC")
wdi = Course.find_by(short_name: "WDI")
pmi = Course.find_by(short_name: "PMI")

wdi7 = Cohort.create!(name: "WDIDC7", location: dc, course: wdi)
pmi1 = Cohort.create!(name: "PMIDC1", location: dc, course: wdi)

wdi7.add_admin(adam)
wdi7.add_member(jesse)
wdi7.add_admin(matt) # for attendance

wdi7.add_member(alice)
wdi7.add_member(bob)
wdi7.add_member(carol)

pmi1.add_admin(jane)
pmi1.add_admin(john)

pmi1.add_member(bob)
pmi1.add_member(carol)

Event.create(title:"test event", cohort: wdi7, date: Time.now)

# TODO: Add back ones tags are implemented -ab
# squad_adam = Group.at_path("ga_wdi_dc_7_squad-adam")
# squad_adam.add_admin(adam, true)
# squad_adam.add_member(jane)
# squad_adam.add_member(john)
# squad_adam.add_member(test_user)
# squad_adam.assignments.create!(title: "Test Assignment1", repo_url: "http://github.com/wdidc/test_repo")
#
# squad_matt = Group.at_path("ga_wdi_dc_7_squad-matt")
# squad_matt.add_admin(matt, true)
# squad_matt.add_member(test_user)
