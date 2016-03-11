require 'rails_helper'

RSpec.feature 'Submission Visibility' do
  before(:all) do
    load "#{Rails.root}/db/seeds/test_seed.rb"
  end

  let(:cohort1) { FactoryGirl.create(:cohort) }
  let(:test_instructor)  { User.create!(:username => 'TEST_INSTRUCTOR',  :password => 'password') }
  let(:test_student) { User.create!(username: 'test_student',  :password => 'password') }
  let(:test_student_membership) { Membership.find_by(user: test_student, cohort: cohort1) }

  let(:public_submission) {
    public_assignment = cohort1.assignments.create(title: "Test Assignment", public: true, base_score: 10)
    public_assignment.submissions.find_by(membership: test_student_membership)
  }
  let(:private_submission) {
    private_assignment = cohort1.assignments.create(title: "Test Assignment", public: false, base_score: 10)
    private_assignment.submissions.find_by(membership: test_student_membership)
  }

  before(:each) {
    cohort1.add_admin(test_instructor)
    cohort1.add_member(test_student)

    public_submission.update!(score: 7)
    private_submission.update!(score: 8)
  }

  scenario 'instructor can see both public and private assignment submission scores' do
    login_user(test_instructor)
    visit(membership_path(test_student_membership))

    expect(page).to have_selector("form[action='/submissions/#{public_submission.id}'] input[value='#{public_submission.score}']")
    expect(page).to have_selector("form[action='/submissions/#{private_submission.id}'] input[value='#{private_submission.score}']")
  end

  scenario 'student can not see private assignment submission scores' do
    login_user(test_student)
    visit(membership_path(test_student_membership))

    within("tr[data-submission-id='#{private_submission.id}'] td.score") do
      expect(page).to_not have_content("#{private_submission.score}")
      expect(page).to have_content("N/A")
    end
  end

  scenario 'student can see public assignment submission scores' do
    login_user(test_student)
    visit(membership_path(test_student_membership))

    within("tr[data-submission-id='#{public_submission.id}'] td.score") do
      expect(page).to_not have_content("N/A")
      expect(page).to have_content("#{public_submission.score}")
    end
  end

end
