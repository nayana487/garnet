# scenario 'can see 10 most recent observations from cohorts you admin' do
#   login_user(test_instructor)
#   visit(root_path)
#   expect(page).to have_content "jane test observation"
#   expect(page).to_not have_content "john test observation"
# end

require 'rails_helper'

RSpec.feature 'Observation Feed' do
  before(:all) do
    load "#{Rails.root}/db/seeds/test_seed.rb"
  end

  let(:cohort1) { FactoryGirl.create(:cohort) }
  let(:cohort2) { FactoryGirl.create(:cohort)}
  let(:test_instructor)  { User.create!(:username => 'TEST_INSTRUCTOR',  :password => 'password') }
  let(:other_instructor) { User.create!(:username => 'OTHER_INSTRUCTOR', :password => 'password') }

  let(:john) { User.find_by(username: 'john') }
  let(:jane) { User.find_by(username: 'jane') }

  before(:each) {
    cohort1.add_admin(test_instructor)
    cohort1.add_admin(other_instructor)
    cohort1.add_member(john)
    cohort1.add_member(jane)

    cohort2.add_admin(other_instructor)
    cohort2.add_member(john)

    tag = Tag.create(name: "test")

    john_membership = john.memberships.find_by(cohort: cohort1)
    john_other_membership = john.memberships.find_by(cohort: cohort2)
    jane_membership = jane.memberships.find_by(cohort: cohort1)

    john_membership.observations.create(status: 1, body: "johns obs from test instructor", admin_id: test_instructor.id)
    jane_membership.observations.create(status: 1, body: "janes obs from other test instructor", admin_id: other_instructor.id)
    john_other_membership.observations.create(status: 1, body: "johns obs from other test instructor", admin_id: other_instructor.id)
  }

  scenario 'should see feed header' do
    login_user(test_instructor)
    visit "/cohorts/#{cohort1.id}/observations"
    expect(page).to have_content "Last 10 Observations"
  end

  scenario 'should see recent observations from all admins in cohort' do
    login_user(test_instructor)
    visit "/cohorts/#{cohort1.id}/observations"
    expect(page).to have_content "johns obs from test instructor"
    expect(page).to have_content "janes obs from other test instructor"
  end

  scenario 'should not see observations from other cohorts' do
    login_user(test_instructor)
    visit "/cohorts/#{cohort1.id}/observations"
    expect(page).to_not have_content "johns obs from other test instructor"

  end
  # scenario 'viewing todos for events' do
  #   login_user(test_instructor)
  #   visit(root_path)
  #   expect(page).to have_content "Jane"
  #   expect(page).to have_content "Test Event"
  # end
  #
  # scenario 'viewing todos for assignments' do
  #   login_user(test_instructor)
  #   visit(root_path)
  #   expect(page).to have_content "Jane"
  #   expect(page).to have_content "Test Assignment"
  # end
  #
  # scenario 'inactive students are not shown on todos' do
  #   login_user(test_instructor)
  #   visit(root_path)
  #   expect(page).to_not have_content "John"
  # end
end
