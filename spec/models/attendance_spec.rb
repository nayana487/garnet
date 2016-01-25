require 'rails_helper'

RSpec.describe Attendance do
  before(:all) do
    load "#{Rails.root}/db/seeds/test_seed.rb"
  end
  describe "#calculate_status" do
    before(:each) do
      @att = Attendance.last
    end
    it "is present if before 9 am" do
      now = Time.parse("1969-07-20 08:59:59")
      allow(Time).to receive(:now) { now }
      expect(@att.calculate_status).to eq(2)
    end
    it "is tardy if before 12pm" do
      now = Time.parse("1969-07-20 11:59:59")
      allow(Time).to receive(:now) { now }
      expect(@att.calculate_status).to eq(1)
    end
    it "is absent if after 1pm" do
      now = Time.parse("1969-07-20 13:00:00")
      allow(Time).to receive(:now) { now }
      expect(@att.calculate_status).to eq(0)
    end
  end
end
