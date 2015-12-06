module FormHelpers

  # Clicks the commit button regardless of id or text
  # ProTip: You probably need to use this in a `within` block.  It submits the first form it finds.
  def submit_form
    find('input[name="commit"]').click
  end
end

RSpec.configure do |config|
  config.include FormHelpers, :type => :feature
end
