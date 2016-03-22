require 'rails_helper'

RSpec.describe Membership do
  before(:all) do
    load "#{Rails.root}/db/seeds/test_seed.rb"
    cohort = Cohort.last
    @m = cohort.memberships.create()
    cohort.events.create!(title:"Some test event2", occurs_at: Time.now)
    @m.attendances.first.present!
    cohort.events.create!(title:"Some test event", occurs_at: Time.now + 3.hours)
    cohort.assignments.create!(title: "Some test assignment")
    cohort.assignments.create!(title: "Some test assignment #2")
    @m.submissions.first.complete!
  end

  let(:ga_root_group) { Group.at_path("ga") }

  describe "tag relationship" do
    it "has many taggings" do
      should have_many(:taggings)
    end
    it "has many tags through taggings" do
      should have_many(:tags)
    end
  end

  describe "average observations" do
    before(:all) do
      @m.observations.create!(status: Observation.statuses[:red])
      @m.observations.create!(status: Observation.statuses[:yellow])
      @m.observations.create!(status: Observation.statuses[:green])
      @original_average = @m.average_observations
    end
    it "returns a Float of the average numbers of the member's observations" do
      expect(@original_average).to be(Observation.statuses[:yellow].to_f)
    end
    it "returns 0 if no observations" do
      cohort = Cohort.first
      @t = cohort.memberships.create()
      expect(@t.average_observations).to eq(0)
    end
    it "returns red status for a member with one red observation" do
      cohort = Cohort.first
      @t = cohort.memberships.create()
      @t.observations.create(status: Observation.statuses[:red])
      expect(@t.average_observations).to be(Observation.statuses[:red].to_f)
    end
    it "is not influenced by neutral status" do
      @m.observations.create(status: Observation.statuses[:neutral])
      expect(@m.average_observations).to eq(@original_average)
    end
  end

  describe "percent from status" do
    it "should not include future attendances" do
      expect(@m.percent_from_status(:attendances, :present)).to eq(100)
    end
    it "should exclude n/a assignments" do
      expect(@m.percent_from_status(:submissions, :complete)).to eq(100)
    end
  end

  describe "#update_percents_of" do
    before(:all) do
      @cohort = Cohort.create!(name: "Test")
      @member = @cohort.add_member(User.last)
      @event = @cohort.events.create!(title: "Test", occurs_at: Time.now)
      @event.attendances.last.update!(status: Attendance.statuses[:present])
    end
    before(:each) do
      @event.update!(occurs_at: Date.yesterday - 100)
      @member.reload
      @percents = @member.percent_attendances
    end
    it "should return averages for all possible statuses" do
      expect(@percents.keys).to match_array(Attendance.statuses.keys)
    end
    it "should be calculated when an event/assignment is created" do
      expect(@percents).to be_instance_of(Hash)
    end
    it "should be recalculated when an event/assignment is updated" do
      @event.update!(occurs_at: Date.tomorrow)
      @member.reload
      expect(@member.percent_attendances).to_not eq(@percents)
    end
    it "should be recalculated when an attendance/submission is updated" do
      @event.attendances.last.update!(status: Attendance.statuses[:absent])
      @member.reload
      expect(@member.percent_attendances).to_not eq(@percents)
    end
    it "should not throw when divisor is 0" do
      @m.submissions.destroy_all
      expect(@m.percent_from_status(:submissions, Submission.statuses[:complete])).to eq(nil)
    end
  end
end
