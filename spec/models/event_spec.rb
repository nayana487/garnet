require 'rails_helper'

RSpec.describe Event do
  before(:all) do
    load "#{Rails.root}/db/seeds/test_seed.rb"
  end

  let(:cohort) { Cohort.last } #any cohort

  describe "(avoiding duplicates, in the same cohort)" do
    it "does NOT allow events within #{Event.duplicate_date_delta / 1.minute} minutes of each other" do
      first_event = cohort.events.create!(occurs_at: (Event.duplicate_date_delta - 1).ago, title: "FIRST")
      too_soon = cohort.events.build(occurs_at: Time.now, title: "TOO SOON")
      expect(too_soon).to_not be_valid
      expect(too_soon.errors[:occurs_at]).to include(/occurs too close/)
    end

    it "does allow another event, after #{Event.duplicate_date_delta / 1.minute} minutes" do
      first_event = cohort.events.create!(occurs_at: (Event.duplicate_date_delta + 1).ago, title: "FIRST")
      enough_delay = cohort.events.build(occurs_at: Time.now, title: "ENOUGH DELAY")
      expect(enough_delay).to be_valid
    end
  end

end
