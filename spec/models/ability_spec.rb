require "rails_helper"
require "cancan/matchers"

load "#{Rails.root}/db/seeds/test_seed.rb"

RSpec.shared_examples "nonadmin" do
  let(:ability) { Ability.new(user) }
  describe "assignments" do
    it "can read all" do
      expect(ability).to be_able_to(:read, Assignment.new(group: group))
    end
  end
  describe "submissions" do
    let(:own_submission) { Submission.new(group: group, user: user) }
    let(:other_submission) { Submission.new(group: group, user: other) }
    it "can read own" do
      expect(ability).to be_able_to(:read, own_submission)
    end
    it "cannot read others'" do
      expect(ability).to_not be_able_to(:read, other_submission)
    end
    it "cannot update others'" do
      expect(ability).to_not be_able_to(:update, other_submission)
    end
  end
  describe "events" do
    it "can read all" do
      expect(ability).to be_able_to(:read, Event.new)
    end
  end
  describe "attendances" do
    let(:own_attendance) { Attendance.new(group: group, user: user) }
    let(:other_attendance) { Attendance.new(group: group, user: other) }
    it "can read own attendances" do
      expect(ability).to be_able_to(:read, own_attendance)
    end
    it "cannot read others' attendances" do
      expect(ability).to_not be_able_to(:read, other_attendance)
    end
  end
  describe "observations" do
    let(:observation) { Observation.new(group: group) }
    it "cannot read any observations" do
      expect(ability).to_not be_able_to(:read, observation)
    end
  end
  describe "memberships" do
    it "cannot update memberships" do
      expect(ability).to_not be_able_to(:update, other)
    end
  end
  describe "group" do
    it "cannot update" do
      expect(ability).to_not be_able_to(:update, group)
    end
  end
  describe "subgroups" do
    it "cannot create any" do
      expect(ability).to_not be_able_to(:create, Group.new(parent: group))
    end
  end
end

RSpec.shared_examples "admin" do
  let(:ability) { Ability.new(user) }
  it "can CRUD nonadmins" do
    expect(ability).to be_able_to(:manage, group.member("bob"))
  end
  it "can CRUD admins" do
    expect(ability).to be_able_to(:manage, group.member("jesse"))
  end
  it "can CRUD assignments" do
    expect(ability).to be_able_to(:manage, Assignment.new(group: group))
  end
  it "can CRUD submissions" do
    expect(ability).to be_able_to(:manage, Submission.new(group: group))
  end
  it "can CRUD events" do
    expect(ability).to be_able_to(:manage, Event.new(group: group))
  end
  it "can CRUD attendances" do
    expect(ability).to be_able_to(:manage, Attendance.new(group: group))
  end
  it "can CRUD observations" do
    expect(ability).to be_able_to(:manage, Observation.new(group: group))
  end
  it "can create subgroups" do
    expect(ability).to be_able_to(:create, Group.new(parent: group))
  end
end

RSpec.describe Ability do
  describe "nonadmin" do
    context "in own group" do
      include_examples "nonadmin" do
        let(:group) { Group.at_path("ga_wdi_dc_7") }
        let(:user) { User.named("alice") }
        let(:other) { User.named("bob") }
      end
    end
    context "in ancestor groups" do
      include_examples "nonadmin" do
        let(:group) { Group.at_path("ga_wdi_dc") }
        let(:user) { User.named("alice") }
        let(:other) { User.named("bob") }
      end
    end
  end

  describe "admin" do
    context "in own group" do
      include_examples "admin" do
        let(:group) { Group.at_path("ga_wdi_dc_7") }
        let(:user) { User.named("adam") }
        let(:nonadmin) { User.named("bob") }
      end
    end
    context "in ancestor group" do
      include_examples "nonadmin" do
        let(:group) { Group.at_path("ga_wdi_dc") }
        let(:user) { User.named("adam") }
        let(:other) { User.named("bob") }
      end
    end
    context "in descendant group" do
      include_examples "nonadmin" do
        let(:group) { Group.at_path("ga_wdi_dc_7_adam") }
        let(:user) { User.named("jesse") }
        let(:other) { User.named("john") }
      end
    end
  end
end
