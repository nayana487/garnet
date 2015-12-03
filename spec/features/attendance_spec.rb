require 'rails_helper'

RSpec.feature 'Taking Attendance', js: true do
  before(:all) do
    load "#{Rails.root}/db/seeds/test_seed.rb"
  end

  given(:ga_root_group) { Group.at_path('ga') }
  given!(:test_instructor) do
    instructor = User.create!(:username => 'TEST_INSTRUCTOR', :password => 'password')
    Group.at_path('ga_wdi_dc_7').add_owner(instructor)
    instructor
  end


  scenario "taking today's attendance" do
    Rails.logger.debug "User.count:#{User.count}, Prior to click SignIn"

    # ISSUE: Login fails.
    #   I can't get the javascript tests to work.
    #   The "test_instructor" we add in this spec
    #   disappears from the database
    #   in between clicking "Sign In" and UsersController#sign_in!
    #   No evidence of rollback or database.clean
=begin Log file
User.count:10, Prior to click SignIn
Started GET "/" for 127.0.0.1 at 2015-12-02 22:33:00 -0500
Processing by UsersController#show as HTML
Redirected to http://127.0.0.1:54098/sign_in
Filter chain halted as :authenticate rendered or redirected
Completed 302 Found in 17ms (ActiveRecord: 0.0ms)
Started GET "/sign_in" for 127.0.0.1 at 2015-12-02 22:33:00 -0500
Processing by UsersController#sign_in as HTML
Rendered users/sign_in.html.erb within layouts/application (3.0ms)
Completed 200 OK in 341ms (Views: 340.3ms | ActiveRecord: 0.0ms)
Started POST "/sign_in" for 127.0.0.1 at 2015-12-02 22:33:01 -0500
Processing by UsersController#sign_in! as HTML
Parameters: {"utf8"=>"✓", "username"=>"test_instructor", "password"=>"[FILTERED]"}
 (0.6ms)  SELECT COUNT(*) FROM "users"
User.count:9, in sign_in!
=end

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
    # mark_attendance("alice", "Present")

    within("[data-attendee='alice']") do
      choose "Present"
    end

    within("[data-attendee='bob']") do
      choose "Tardy"
    end

    within("[data-attendee='carol']") do
      choose "Absent"
    end
save_and_open_page
    visit page.current_url # refresh current page to check persistence
save_and_open_page
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
