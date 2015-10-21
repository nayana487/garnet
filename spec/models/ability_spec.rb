require "rails_helper"
require "cancan/matchers"

RSpec.shared_examples "nonadmin" do
  describe "assignments" do
    it "can read all"
  end
  describe "submissions" do
    it "can read own"
    it "cannot read others'"
    it "cannot update others'"
  end
  describe "events" do
    it "can read all"
  end
  describe "attendances" do
    it "can read own attendances"
    it "cannot read others' attendances"
  end
  describe "observations" do
    it "cannot read any observations"
  end
  describe "memberships" do
    it "cannot update memberships"
  end
end

RSpec.shared_examples "admin" do
  it "can CRUD nonadmins"
  it "can CRUD admins"
  it "can CRUD assignments"
  it "can CRUD submissions"
  it "can CRUD events"
  it "can CRUD attendances"
  it "can CRUD observations"
end

RSpec.describe Ability do
  describe "nonadmin" do
    context "in own group" do
      include_examples "nonadmin"
    end
    context "in ancestor groups" do
      include_examples "nonadmin"
    end
  end

  describe "admin" do
    context "in own group" do
      include_examples "admin"
    end
    context "in ancestor group" do
      include_examples "nonadmin"
    end
    context "in descendant group" do
      include_examples "nonadmin"
    end
  end
end
