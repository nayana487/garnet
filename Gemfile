source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.4'
# Use postgresql as the database for Active Record
gem 'pg'

# >>>>>>>>>>>>>>>>>>>>>>>>>
# remaining gems are sorted alphabetically
gem 'ancestry'
gem 'bcrypt' # Use ActiveModel has_secure_password
gem 'cancancan'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
gem 'figaro'
gem 'font-awesome-rails'
gem 'httparty'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'octokit'
# Redcarpet is a Ruby library for Markdown processing that smells like butterflies and popcorn.
gem 'redcarpet'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# use redcarpet for markdown support
gem 'coderay'

group :production do
  # WORKAROUND: had difficulties debugging with unicorn, reverted to Webrick for dev
  gem 'unicorn-rails'
end

group :development, :test do
  gem 'capybara'
  gem 'launchy' # for capybara, save_and_open_page
  gem 'newrelic_rpm' # http://newrelic.com/ruby

  # Call 'binding.pry', 'debugger', or 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'pry-byebug'
  gem 'rspec-rails', '~> 3.0'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'


end

group :development do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', '~> 0.4.0', group: :doc

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem 'spring'
end
