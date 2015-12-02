module FormHelpers
  # Clicks the commit button regardless of id or text
  def submit_form
    find('input[name="commit"]').click
  end
end

RSpec.configure do |config|
  config.include FormHelpers, :type => :feature
end
