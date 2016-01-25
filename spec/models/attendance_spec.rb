require 'rails_helper'

RSpec.describe Attendance do
  before(:all) do
    load "#{Rails.root}/db/seeds/test_seed.rb"
  end
  describe "#calculate_status" do
    before(:each) do
      @att = Attendance.last
      p @att
    end
    it "is present if before 9 am" do
      now = Time.parse("1969-07-20 08:59:59")
      allow(Time).to receive(:now) { now }
      expect(@att.calculate_status).to eq(2)
    end
  end
end
