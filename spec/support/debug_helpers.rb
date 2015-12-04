module DebugHelpers
  # pauses javascript spec, with browser available for introspection
  def pause
    print "Paused.  Press return to continue..."
    STDIN.getc
  end
end

RSpec.configure do |config|
  config.include DebugHelpers, :type => :feature
end
