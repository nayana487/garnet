require 'rails_helper'

RSpec.describe Cohort do
  let(:test_cohort) { Cohort.create!(name: "Test Cohort", start_date: DateTime.parse("1969-07-20 08:34:59"), end_date: DateTime.parse("1969-07-27 08:59:59"))}
  let(:start_time) { 9 }
  describe "#generate_events" do

    before(:each) do
      test_cohort.events.destroy_all
    end
    it "creates events with a specified start time" do
      test_cohort.generate_events(start_time)
      expect(test_cohort.events.sample.occurs_at.hour).to eq(start_time)
    end

    it "creates events for weekdays" do
      test_cohort.generate_events(start_time)
      num_weekdays = 5
      num_events = test_cohort.events.length
      expect(num_events).to eq(num_weekdays)
    end

    it "does not create events for weekends" do
      test_cohort.generate_events(start_time)
      # wday of a date time will return 0 for sunday and 6 for saturday, weekdays are 1 - 5
      weekend_events = test_cohort.events.any?{|event| event.occurs_at.wday == 0 || event.occurs_at.wday == 6}
      expect(weekend_events).to eq(false)
    end

    it "does not create duplicate events" do
      test_cohort.generate_events(start_time)
      num_events_before_running_method_again = test_cohort.events.length
      test_cohort.generate_events(start_time)
      num_events_after_running_method_again = test_cohort.events.length
      expect(num_events_before_running_method_again).to eq(num_events_after_running_method_again)
    end
  end
end
