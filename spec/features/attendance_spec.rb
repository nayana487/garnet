require 'rails_helper'

RSpec.feature 'Taking Attendance', js: true do
  before(:all) do
    load "#{Rails.root}/db/seeds/test_seed.rb"
  end

  given(:ga_root_group) { Group.at_path('ga') }
  given(:group_under_test) { Group.at_path('ga_wdi_dc_7') }
  given!(:test_instructor) do
    instructor = User.create!(:username => 'TEST_INSTRUCTOR', :password => 'password')
    group_under_test.add_owner(instructor)
    instructor
  end


  scenario "taking today's attendance" do
    # Given
    login_user(test_instructor)

    # visit group show, with expanded Attendance section
    visit group_path(group_under_test, anchor: 'attendance')

    # on group show page
    within('#new_event') do
      fill_in "event_title", with: "TEST ATTENDANCE"
      # use default date time (now)
      submit_form # Clicks the commit button regardless of id or text
    end

    # When
    # on attendance event show page
    expect(page).to have_css("h1", "TEST EVENT")

    within("[data-attendee='alice']") do
      choose "Present"
    end

    within("[data-attendee='bob']") do
      choose "Tardy"
    end

    within("[data-attendee='carol']") do
      choose "Absent"
    end

    visit page.current_url # refresh current page to check persistence
    # Then
    within("[data-attendee='alice']") do |element|
      expect(page).to have_checked_field("Present")
    end

    within("[data-attendee='bob']") do
      expect(page).to have_checked_field("Tardy")
    end

    within("[data-attendee='carol']") do
      expect(page).to have_checked_field("Absent")
    end
  end
end
