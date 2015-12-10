require 'rails_helper'

RSpec.feature "the login process" do
  given!(:test_user) do
    FactoryGirl.create(:user)
  end

  scenario "sign in via username & password" do
    login_user(test_user)
    expect(page).to have_content "You're signed in"
  end

  scenario "sign_out" do
    login_user(test_user)

    click_on "sign out"
    expect(page).to have_content "signed out"
  end
end
