load "#{Rails.root}/db/seeds.rb"
# ActiveRecord::Base.logger = Logger.new(STDOUT)

test_user = FactoryGirl.create(:user, username: "TestWDIDCStudent", github_id: 13137527)
jane      = FactoryGirl.create(:user, username: "jane")
john      = FactoryGirl.create(:user, username: "john")
alice     = FactoryGirl.create(:user, username: "alice")
bob       = FactoryGirl.create(:user, username: "bob")
carol     = FactoryGirl.create(:user, username: "carol")
adam      = FactoryGirl.create(:user, username: "adam")
jesse     = FactoryGirl.create(:user, username: "jesse")
matt      = FactoryGirl.create(:user, username: "mattscilipoti", github_id: '31929')

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
