require 'rails_helper'

RSpec.describe Event do
  let(:cohort) { Cohort.last } #any cohort

  context "when created" do
    it "creates attendances for all members of the event's cohort"
  end

  describe "(avoiding duplicates, in the same cohort)" do
    it "does NOT allow events within #{Event.duplicate_date_delta / 1.minute} minutes of each other" do
      first_event = cohort.events.create!(date: (Event.duplicate_date_delta - 1).ago, title: "FIRST")
      too_soon = cohort.events.build(date: Time.now, title: "TOO SOON")
      expect(too_soon).to_not be_valid
      expect(too_soon.errors[:date]).to include(/occurs too close/)
    end

    it "does allow another event, after #{Event.duplicate_date_delta / 1.minute} minutes" do
      first_event = cohort.events.create!(date: (Event.duplicate_date_delta + 1).ago, title: "FIRST")
      enough_delay = cohort.events.build(date: Time.now, title: "ENOUGH DELAY")
      expect(enough_delay).to be_valid
    end
  end

end
