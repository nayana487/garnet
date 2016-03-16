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
  let(:dave) { User.find_by(username: 'jane') }

  before(:each) {
    cohort1.add_admin(test_instructor)
    cohort1.add_admin(other_instructor)
    cohort1.add_member(john)
    cohort1.add_member(jane)

    cohort2.add_admin(other_instructor)
    cohort2.add_member(dave)

    john_cohort1 = john.memberships.find_by(cohort: cohort1)
    jane_cohort1 = jane.memberships.find_by(cohort: cohort1)
    dave_cohort2 = dave.memberships.find_by(cohort: cohort2)

    @allowed_obs1 = john_cohort1.observations.create(status: 1, body: "john in cohort1", admin_id: test_instructor.id)
    @allowed_obs2 = jane_cohort1.observations.create(status: 1, body: "jane in cohort1", admin_id: other_instructor.id)
    @denied_obs1  = dave_cohort2.observations.create(status: 1, body: "dave in cohort2", admin_id: other_instructor.id)
  }

  scenario 'should see feed header' do
    login_user(test_instructor)
    visit observations_cohort_path(cohort1)
    expect(page).to have_content "Last 10 Observations"
  end

  scenario 'should see recent observations from all admins in cohort' do
    login_user(test_instructor)
    visit observations_cohort_path(cohort1)
    expect(page).to have_content @allowed_obs1.body
    expect(page).to have_content @allowed_obs2.body
  end

  scenario 'should not see observations from other cohorts' do
    login_user(test_instructor)
    visit observations_cohort_path(cohort2)
    expect(page).to_not have_content @denied_obs1.body
  end
end
