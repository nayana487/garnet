require 'rails_helper'

RSpec.feature 'Instructor Dashboard' do
  before(:all) do
    load "#{Rails.root}/db/seeds/test_seed.rb"
  end

  let(:cohort1) { FactoryGirl.create(:cohort) }

  let(:test_instructor)  { User.create!(:username => 'TEST_INSTRUCTOR',  :password => 'password') }
  let(:other_instructor) { User.create!(:username => 'OTHER_INSTRUCTOR', :password => 'password') }

  let(:john) { User.find_by(username: 'john') }
  let(:jane) { User.find_by(username: 'jane') }

  before(:each) {
    cohort1.add_admin(test_instructor)
    cohort1.add_member(john)
    cohort1.add_member(jane)

    tag = Tag.create(name: "test")

    test_instructor_membership = test_instructor.memberships.find_by(cohort: cohort1)
    john_membership = john.memberships.find_by(cohort: cohort1)
    jane_membership = jane.memberships.find_by(cohort: cohort1)

    test_instructor_membership.taggings.create(tag: tag)
    john_membership.taggings.create(tag: tag)
    jane_membership.taggings.create(tag: tag)

    cohort1.events.create!(title: "Test Event", occurs_at: 1.hour.ago)
    cohort1.assignments.create(title: "Test Assignment", due_date: 2.days.ago)

    john_membership.inactive!
  }

  scenario 'when signed in' do
    login_user(test_instructor)
    expect(page).to have_content "You're signed in, #{test_instructor.username}"
  end

  scenario 'viewing todos for events' do
    login_user(test_instructor)
    visit(root_path)
    expect(page).to have_content "Jane"
    expect(page).to have_content "Test Event"
  end

  scenario 'viewing todos for assignments' do
    login_user(test_instructor)
    visit(root_path)
    expect(page).to have_content "Jane"
    expect(page).to have_content "Test Assignment"
  end

  scenario 'inactive students are not shown on todos' do
    login_user(test_instructor)
    visit(root_path)
    expect(page).to_not have_content "John"
  end
end
