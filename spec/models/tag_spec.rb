require 'rails_helper'

RSpec.describe Tag do
  before(:all) do
    load "#{Rails.root}/db/seeds/test_seed.rb"
  end

  let(:ga_root_group) { Group.at_path("ga") }

  describe "name" do
    tag = Tag.create(name: "bob")
    it "has a name" do
      expect(tag.name).to eq("bob")
    end
    it "should have many taggings" do
      should have_many(:taggings)
    end
    it "should have many memberships through taggings" do
      should have_many(:memberships)
    end
  end

end
