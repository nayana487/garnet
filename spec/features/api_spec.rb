require 'rails_helper'

RSpec.feature "api spec", :type => :feature do
  before(:all) do
    load "#{Rails.root}/db/seeds/test_seed.rb"
    @user = User.last
    @user_membership = @user.memberships.first
    @cohort = @user_membership.cohort
    @other_user_membership = @cohort.memberships.where.not(user_id: @user.id).first
    @user_tag = @user_membership.tags.create(name: "hotdog")
    @other_user_tag = @other_user_membership.tags.create(name: "hamburger")
    @user.generate_api_token
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

  scenario "filter memberships by tag" do
    visit api_cohort_memberships_path(@cohort, api_token: @user.api_token, tag: @other_user_tag.name)
    expect(page).not_to have_content(@user.name)
    expect(page).to have_content(@other_user_membership.user.name)
  end

  scenario "filter members by multiple tags" do
    
  end



end
