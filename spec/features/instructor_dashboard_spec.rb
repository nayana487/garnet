require 'rails_helper'

RSpec.feature 'Instructor Dashboard' do
  before(:all) do
    load "#{Rails.root}/db/seeds/test_seed.rb"
  end

  let(:test_instructor) { User.create!(:username => 'TEST_INSTRUCTOR', :password => 'password') }
  let(:other_instructor) { User.create!(:username => 'OTHER_INSTRUCTOR', :password => 'password') }

  let(:test_student)  { User.find_by(github_id: 13137527) }
  let(:test_student2) { User.find_by(username: 'jane') }


  scenario 'when signed in' do
    login_user(test_instructor)
    expect(page).to have_content "You're signed in, #{test_instructor.username}"
  end
end
