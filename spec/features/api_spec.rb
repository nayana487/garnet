require 'rails_helper'

RSpec.feature "api spec", :type => :feature do
  before(:all) do
    load "#{Rails.root}/db/seeds/test_seed.rb"
    @john = User.last
    @john_membership = @john.memberships.first
    @cohort = @john_membership.cohort
    @jane_membership = @cohort.memberships.where.not(user_id: @john.id).first
    @tarzan_user_membership = @cohort.memberships.where.not(user_id: [@john.id, @jane_membership.user.id]).first
    @john_tag = @john_membership.tags.create(name: "hotdog")
    @john_tag1 = @john_membership.tags.create(name: "hamburger")
    @jane_tag = @jane_membership.taggings.create(tag: @john_tag)
    @john.generate_api_token
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
    visit api_cohort_memberships_path(@cohort, api_token: @john.api_token, tag: @jane_tag.name)
    expect(page).not_to have_content(@tarzan_user_membership.user.name)
    expect(page).to have_content(@jane_membership.user.name)
  end

  scenario "filter members by multiple tags" do
    tags = [@jane_tag.name, @john_tag.name]
    visit api_cohort_memberships_path(@cohort, api_token: @john.api_token, tag: "#{@jane_tag.name}|#{@john_tag.name}")
    expect(page).to have_content(@john.name)
    expect(page).to have_content(@jane_membership.user.name)
    expect(page).not_to have_content(@tarzan_user_membership.user.name)
    @names = @cohort.memberships.filter_by_tag("#{@john_tag.name}|#{@john_tag1.name}")
    expect(@names.length).to eq(@names.uniq.length)
  end



end
