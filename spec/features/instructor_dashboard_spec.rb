require 'rails_helper'

RSpec.feature 'Instructor Dashboard' do
  before(:all) do
    load "#{Rails.root}/db/seeds/test_seed.rb"
  end

  let(:ga_root_group) { Group.at_path('ga') }
  let(:test_instructor) { User.create!(:username => 'TEST_INSTRUCTOR', :password => 'password') }
  let(:other_instructor) { User.create!(:username => 'OTHER_INSTRUCTOR', :password => 'password') }

  let(:test_student)  { User.find_by(github_id: 13137527) }
  let(:test_student2) { User.find_by(username: 'jane') }

  let(:dashboard_squad1) do
    group = ga_root_group.children.create!(title: "TESTSQUAD1")
    group.add_owner(test_instructor, true)
    group.add_member(test_student)
    group
  end

  let(:dashboard_squad2) do
    group = ga_root_group.children.create!(title: "TESTSQUAD2")
    group.add_owner(other_instructor, true)
    group.add_member(test_student2)
    group
  end

  before :each do
    dashboard_squad1.assignments.create!(title: "Test Assignment1", repo_url: "http://github.com/wdidc/test_repo")
  end

  scenario 'when signed in' do
    login_user(test_instructor)
    expect(page).to have_content "Welcome, #{test_instructor.username}"

    click_on "Test Assignment1"

    submission_rows = page.all('#submissions .submission')

    displayed_students = submission_rows.collect {|row| row.find('td:first-of-type').text }

    # should only see members of squad1
    expected_students = dashboard_squad1.nonadmins.collect(&:username)
    expect(displayed_students).to match_array(expected_students)
  end
end
