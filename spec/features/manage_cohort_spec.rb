require 'rails_helper'

RSpec.feature 'Manage Cohort' do
  before(:all) do
    load "#{Rails.root}/db/seeds/test_seed.rb"
  end

  let(:cohort1) { FactoryGirl.create(:cohort) }

  let(:test_instructor)  { User.create!(:username => 'TEST_INSTRUCTOR', name: 'bob', :password => 'password') }
  let(:other_instructor) { User.create!(:username => 'OTHER_INSTRUCTOR', name: 'mary', :password => 'password') }

  before(:each) {
    cohort1.add_admin(test_instructor)
    cohort1.add_member(other_instructor)
  }

  scenario 'can remove members' do
    other_instrutor_membership_id = other_instructor.memberships.first.id
    login_user(test_instructor)
    visit manage_cohort_path(test_instructor.cohorts.first)
    expect(page).to have_selector("tr[data-membership-id='#{other_instrutor_membership_id}']")
    page.find("tr[data-membership-id='#{other_instrutor_membership_id}']").click_link("Remove")
    expect(page).not_to have_selector("tr[data-membership-id='#{other_instrutor_membership_id}']")
  end

  scenario 'can make exisiting members admin' do
    other_instructor_membership = other_instructor.memberships.first
    login_user(test_instructor)
    visit manage_cohort_path(test_instructor.cohorts.first)

    within("tr[data-membership-id='#{other_instructor_membership.id}']") do
      expect(page).to have_content("make admin")
      click_link("make admin")
    end
    # repeated for page refresh
    within("tr[data-membership-id='#{other_instructor_membership.id}']") do
      expect(page).to have_content("remove as admin")
    end
  end

  scenario 'can make exisiting admins non admin' do
    other_instructor_membership = other_instructor.memberships.first
    other_instructor_membership.is_admin = true
    other_instructor_membership.save
    login_user(test_instructor)
    visit manage_cohort_path(test_instructor.cohorts.first)

    within("tr[data-membership-id='#{other_instructor_membership.id}']") do
      expect(page).to have_content("remove as admin")
      click_link("remove as admin")
    end
    # repeated for page refresh
    within("tr[data-membership-id='#{other_instructor_membership.id}']") do
      expect(page).to have_content("make admin")
    end
  end
end
