require 'rails_helper'

RSpec.feature "api spec", :type => :feature do
  before(:all) do
    load "#{Rails.root}/db/seeds/test_seed.rb"
  end
  let(:test_instructor) { User.create!(:username => 'test_instructor', :password => 'password') }
  let(:test_instructor2) { User.create!(:username => 'test_instructor2', :password => 'password') }

  scenario "get information about a user" do
    login_user(test_instructor)
    # visit cohort show, with expanded Attendance section
    test_instructor2.generate_api_token
    visit api_user_path + "?api_token=" + test_instructor2.api_token
    expect(page).to have_content("test_instructor2")
  end
end
