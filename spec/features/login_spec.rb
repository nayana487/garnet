require 'rails_helper'

RSpec.describe "the login process", :type => :feature do
  before :each do
    User.create(:username => 'testuser', :password => 'password')
  end

  scenario "sign in via username & password" do
    visit '/sign_in'
    within("main") do
      fill_in 'username', :with => 'testuser'
      fill_in 'password', :with => 'password'
      click_button 'Sign in'
    end

    expect(page).to have_content "You're signed in"
  end
end
