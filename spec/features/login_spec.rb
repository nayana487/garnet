require 'rails_helper'

describe "the login process", :type => :feature do
  before :each do
    User.create(:username => 'testuser', :password => 'password')
  end

  it "signs a user in" do
    visit '/sign_in'
    within("main") do
      fill_in 'username', :with => 'testuser'
      fill_in 'password', :with => 'password'
    end
    click_button 'Sign in'
    expect(page).to have_content "You're signed in"
  end
end
