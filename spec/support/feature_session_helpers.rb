module FeatureSessions
  def login_user(user)
    visit root_path
    within("main") do
      fill_in 'username', :with => user.username
      fill_in 'password', :with => user.password
    end
    click_button 'Sign in'
    expect(page).to have_content "You're signed in"
  end
end

RSpec.configure do |config|
  config.include FeatureSessions, :type => :feature
end
