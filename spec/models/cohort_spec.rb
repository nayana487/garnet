require 'rails_helper'

RSpec.describe Cohort do
  before(:all) do
    let(:test_cohort) { Cohort.create!(name: "Test Cohort" start_date: DateTime.parse("1969-07-20 08:34:59"), end_date: DateTime.parse("1969-07-27 08:59:59"))}
    let(:test_student)  { User.create!(:username => 'test student',  :password => 'password') }
  end
  describe "#generate_events" do

    before(:each) do
      test_cohort.add_member(test_student)
      # @evt = Event.create(title: "Test Event", occurs_at: Time.parse("1969-07-20 09:00:00"), cohort: Cohort.last)
      # @att = @evt.attendances.last
    end
    it "creates events with a specified start time" do

    end

    it "creates events for weekdays" do
      now = Time.parse("1969-07-20 08:59:59")
      allow(Time).to receive(:now) { now }
      expect(@att.calculate_status).to eq(Attendance.statuses[:present])
    end
    it "does not create events for weekends" do
      now = Time.parse("1969-07-20 11:59:59")
      allow(Time).to receive(:now) { now }
      expect(@att.calculate_status).to eq(Attendance.statuses[:tardy])
    end
  end
end
