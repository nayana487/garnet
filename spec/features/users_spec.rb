require 'rails_helper'
require_relative 'helpers/login_helper'

RSpec.describe "user pages", :type => :feature do
  before :each do
    User.create(:username => 'testuser', :password => 'password')
  end

  scenario "sign in via username & password" do
    sign_in_as('testuser', 'password')
    expect(page).to have_content "You're signed in"
  end

  scenario "sign_out" do
    sign_in_as('testuser', 'password')

    click_on "sign out"
    expect(page).to have_content "signed out"
  end
end
