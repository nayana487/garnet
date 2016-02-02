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
  end

end
