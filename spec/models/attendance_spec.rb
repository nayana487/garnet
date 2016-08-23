require 'rails_helper'

RSpec.describe Attendance do
  before(:all) do
    load "#{Rails.root}/db/seeds/test_seed.rb"
  end
  describe "#calculate_status" do

    before(:each) do
      @evt = Event.create(title: "Test Event", occurs_at: Time.parse("1969-07-20 09:00:00"), cohort: Cohort.last)
      @att = @evt.attendances.last
    end
    it "is present if before 9 am" do
      now = Time.parse("1969-07-20 08:59:59")
      allow(Time).to receive(:now) { now }
      expect(@att.calculate_status).to eq(Attendance.statuses[:present])
    end
    it "is tardy if before 12pm" do
      now = Time.parse("1969-07-20 11:59:59")
      allow(Time).to receive(:now) { now }
      expect(@att.calculate_status).to eq(Attendance.statuses[:tardy])
    end
    it "is absent if after 1pm" do
      now = Time.parse("1969-07-20 13:00:00")
      allow(Time).to receive(:now) { now }
      expect(@att.calculate_status).to eq(Attendance.statuses[:absent])
    end
    it "is unmarked if created individually" do
      membership_id = Cohort.last.memberships.last.id
      attendance = @evt.attendances.create(membership_id: membership_id)
      # the alternative to the below eq is the string "unmarked", not sure which is better
      expect(attendance.status).to eq(Attendance.statuses.keys[Attendance.statuses[:unmarked]])
    end
  end
end
