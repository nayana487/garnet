require 'rails_helper'

RSpec.describe "user pages" do
  let(:test_user) do
    FactoryGirl.create(:user)
  end
  let(:cohort1) { FactoryGirl.create(:cohort) }
  let(:test_instructor)  { User.create!(:username => 'TEST_INSTRUCTOR',  :password => 'password') }

  let(:test_user_2) do
    FactoryGirl.create(:user)
  end
  let(:test_user_2)  { User.create!(:username => 'TEST_USER_2',  :password => 'password') }



  scenario "looking at user you admin" do
    cohort1.add_admin(test_instructor)
    cohort1.add_member(test_user)

    login_user(test_instructor)
    visit(user_path test_user)
    expect(page).to have_css("[data-is-editable='true']")
  end

  scenario "looking at user you don't admin" do
    cohort1.add_member(test_user)
    cohort1.add_member(test_user_2)
    login_user(test_user)
    visit(user_path test_user_2)
    save_and_open_page
    expect(page).to have_css("[data-is-editable='false']")
  end

end
