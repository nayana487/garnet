require 'rails_helper'

RSpec.feature 'Taking Attendance', js: true do
  before(:all) do
    load "#{Rails.root}/db/seeds/test_seed.rb"
  end

  given(:cohort_under_test) { Cohort.find_by(name: 'WDIDC7') }
  given!(:test_instructor) do
    instructor = User.create!(:username => 'TEST_INSTRUCTOR', :password => 'password')
    cohort_under_test.add_admin(instructor)
    instructor
  end


  scenario "taking today's attendance", skip: true, reason: "test flickers due to JS ajax" do
    # Given
    login_user(test_instructor)

    # visit cohort show, with expanded Attendance section
    visit cohort_path(cohort_under_test, anchor: 'attendance')

    # on cohort show page
    within('#new_event') do
      fill_in "event_title", with: "TEST EVENT"
      # use default date time (now)
      submit_form # Clicks the commit button regardless of id or text
    end

    # When
    # on attendance event show page
    expect(page).to have_css("h1", text: /^TEST EVENT/)

    within("[data-attendee='alice']") do
      choose "Present"
    end

    within("[data-attendee='bob']") do
      choose "Tardy"
    end

    within("[data-attendee='carol']") do
      choose "Absent"
    end

    wait_for_ajax # workaround for race conditions between choose absent and expect h1

    visit page.current_url # refresh current page to check persistence
    # ensure page is ready by checking content
    expect(page).to have_css("h1", "TEST EVENT")

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
