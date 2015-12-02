require 'rails_helper'

RSpec.feature 'Taking Attendance' do
  before(:all) do
    load "#{Rails.root}/db/seeds/test_seed.rb"
  end

  let(:ga_root_group) { Group.at_path('ga') }
  let(:test_instructor) do
    instructor = User.create!(:username => 'TEST_INSTRUCTOR', :password => 'password')
    Group.at_path('ga_wdi_dc_7').add_owner(instructor)
    instructor
  end


  scenario "taking today's attendance" do
    login_user(test_instructor)

    within("#groups_section") do
      click_on "7" # for ga_wdi_dc_7
    end

    # on group show page
    within("#attendance_section") do
      fill_in "Title", with: "TEST ATTENDANCE"
      # use default date time (now)
      submit_form # Clicks the commit button regardless of id or text
    end

    # on attendance event show page
    expect(page).to have_css("h1", "TEST EVENT")

    # TODO: mark students
    # TODO: these require javascript support during specs (due to ajax)
  end
end
