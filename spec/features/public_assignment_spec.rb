require 'rails_helper'

RSpec.feature 'Submission Visibility' do
  before(:all) do
    load "#{Rails.root}/db/seeds/test_seed.rb"
  end

  let(:cohort1) { FactoryGirl.create(:cohort) }

  let(:test_instructor)  { User.create!(:username => 'TEST_INSTRUCTOR',  :password => 'password') }

  let(:sammy) { User.create!(username: 'sammy',  :password => 'password') }

  let(:test_instructor_membership) { Membership.find_by(user: test_instructor, cohort: cohort1) }
  let(:sammy_membership) { Membership.find_by(user: sammy, cohort: cohort1) }

  let(:public_assignment) { cohort1.assignments.create(title: "Test Assignment", public: true, base_score: 10) }
  let(:private_assignment) { cohort1.assignments.create(title: "Test Assignment", public: false, base_score: 10) }

  let(:public_submission) { public_assignment.submissions.find_by(membership: sammy_membership) }
  let(:private_submission) { private_assignment.submissions.find_by(membership: sammy_membership) }

  before(:each) {
    cohort1.add_admin(test_instructor)
    cohort1.add_member(sammy)

    public_submission.score = 7
    private_submission.score = 8

    public_submission.save
    private_submission.save
  }

  scenario 'instructor can see both public and private assignment submission scores' do
    login_user(test_instructor)
    visit(membership_path(sammy_membership))

    expect(page).to have_selector("form[action='/submissions/#{public_submission.id}'] input[value='7']")
    expect(page).to have_selector("form[action='/submissions/#{private_submission.id}'] input[value='8']")
  end

  scenario 'student can not see private assignment submission scores' do
    login_user(sammy)
    visit(membership_path(sammy_membership))

    within("tr[data-submission-id='#{private_submission.id}'] td.score") do
      expect(page).to_not have_content("8")
      expect(page).to have_content("N/A")
    end
  end

  scenario 'student can see public assignment submission scores' do
    login_user(sammy)
    visit(membership_path(sammy_membership))

    within("tr[data-submission-id='#{public_submission.id}'] td.score") do
      expect(page).to_not have_content("N/A")
      expect(page).to have_content("7")
    end
  end

end
