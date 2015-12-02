def sign_in_as(username, password)
  visit '/sign_in'
    within("main") do
      fill_in 'username', :with => username
      fill_in 'password', :with => password
      click_button 'Sign in'
    end
end
