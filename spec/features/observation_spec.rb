require 'rails_helper'

RSpec.feature "observation taking process" do
  given!(:test_user) do
    FactoryGirl.create(:user)
  end
  let(:cohort1) { FactoryGirl.create(:cohort) }
  let(:test_instructor)  { User.create!(:username => 'TEST_INSTRUCTOR',  :password => 'password') }

  scenario "sign in via username & password" do
    cohort1.add_admin(test_instructor)
    cohort1.add_member(test_user)

    login_user(test_instructor)

    expect(page).to have_content "You're signed in"

    visit membership_path(test_user.memberships.first)
    within('#new_observation') do
      # use default date time (now)
      select "red", :from => "observation[status]"
      fill_in 'observation[body]', :with => "TEST OBSERVATION"
      submit_form # Clicks the commit button regardless of id or text
    end

    expect(page).to have_content("TEST OBSERVATION")
  end
end
