require 'rails_helper'

RSpec.describe "api spec", :type => :feature do
  let(:test_instructor) { User.create!(:username => 'TEST_INSTRUCTOR', :password => 'password') }
  given!(:test_instructor) do
    instructor = User.create!(:username => 'TEST_INSTRUCTOR', :password => 'password')
    cohort_under_test.add_admin(instructor)
    instructor
  end
  scenario "get information about a user" do
    login_user(test_instructor)
    # visit cohort show, with expanded Attendance section
    visit api_user_path(cohort_under_test, anchor: 'members')

    expect(page).to have_css("th", text: /^Average Observations/)
  end
end
