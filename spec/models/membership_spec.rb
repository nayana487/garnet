require 'rails_helper'

RSpec.describe Membership do
  before(:all) do
    load "#{Rails.root}/db/seeds/test_seed.rb"
    cohort = Cohort.last
    @m = cohort.memberships.create()
    @m.observations.create(status: 0)
    @m.observations.create(status: 0)
    @m.observations.create(status: 1)
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
    it "has an average observations method" do
      expect(@m.average_observations).to eq(0.33)
    end
    it "has average observations that are a float" do
      expect(@m.average_observations).to be_a(Float)
    end
    it "has average observations equal to zero as a float " do
      cohort = Cohort.first
      @t = cohort.memberships.create()
      @t.observations.create(status: 0)
      expect(@t.average_observations).to be(0.0)
    end
    it "has a default value if no observations" do
      cohort = Cohort.first
      @t = cohort.memberships.create()
      expect(@t.average_observations).to be(0.0)
    end
  end

end
