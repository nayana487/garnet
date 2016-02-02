require 'rails_helper'

RSpec.feature 'Cohort Show Page', js: true do
  before(:all) do
    load "#{Rails.root}/db/seeds/test_seed.rb"
  end
  given(:cohort_under_test) { Cohort.find_by(name: 'WDIDC7') }
  given!(:test_instructor) do
    instructor = User.create!(:username => 'TEST_INSTRUCTOR', :password => 'password')
    cohort_under_test.add_admin(instructor)
    instructor
  end
  scenario "View average observations" do
    login_user(test_instructor)
    # visit cohort show, with expanded Attendance section
    visit cohort_path(cohort_under_test, anchor: 'members')

    expect(page).to have_css("th", text: /^Average Observations/)
  end
end
