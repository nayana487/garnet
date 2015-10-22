require "rails_helper"
require "cancan/matchers"

# load "#{Rails.root}/db/seeds/test_seed.rb"

RSpec.shared_examples "nonadmin" do
  let(:ability) { Ability.new(user) }
  describe "assignments" do
    it "can read all"
      # expect(ability).to be_able_to(:read, Assignment.new(group: group))
  end
  describe "submissions" do
    let(:own_submission) { Submission.new(group: group, user: user) }
    let(:other_submission) { Submission.new(group: group, user: other) }
    it "can read own"
      # expect(ability).to be_able_to(:read, own_submission)
    it "cannot read others'"
      # expect(ability).to_not be_able_to(:read, other_submission)
    it "cannot update others'"
      # expect(ability).to_not be_able_to(:update, other_submission)
  end
  describe "events" do
    it "can read all"
      # expect(ability).to be_able_to(:read, Event.new)
  end
  describe "attendances" do
    let(:own_attendance) { Attendance.new(group: group, user: user) }
    let(:other_attendance) { Attendance.new(group: group, user: other) }
    it "can read own"
      # expect(ability).to be_able_to(:read, own_attendance)
    it "cannot read others'"
      # expect(ability).to_not be_able_to(:read, other_attendance)
  end
  describe "observations" do
    let(:observation) { Observation.new(group: group) }
    it "cannot read any"
      # expect(ability).to_not be_able_to(:read, observation)
  end
  describe "memberships" do
    it "cannot update"
      # expect(ability).to_not be_able_to(:update, other)
  end
  describe "group" do
    it "cannot update"
      # expect(ability).to_not be_able_to(:update, group)
  end
  describe "subgroups" do
    it "cannot create any"
      # expect(ability).to_not be_able_to(:create, Group.new(parent: group))
  end
end

RSpec.shared_examples "admin" do
  let(:ability) { Ability.new(user) }
  it "can CRUD nonadmins"
    # expect(ability).to be_able_to(:manage, group.member("bob"))
  it "can CRUD admins"
    # expect(ability).to be_able_to(:manage, group.member("jesse"))
  it "can CRUD assignments"
    # expect(ability).to be_able_to(:manage, Assignment.new(group: group))
  it "can CRUD submissions"
    # expect(ability).to be_able_to(:manage, Submission.new(group: group))
  it "can CRUD events"
    # expect(ability).to be_able_to(:manage, Event.new(group: group))
  it "can CRUD attendances"
    # expect(ability).to be_able_to(:manage, Attendance.new(group: group))
  it "can CRUD observations"
    # expect(ability).to be_able_to(:manage, Observation.new(group: group))
  it "can create subgroups"
    # expect(ability).to be_able_to(:create, Group.new(parent: group))
end

RSpec.describe Ability do
  describe "nonadmin" do
    context "in own group" do
      include_examples "nonadmin"
        # let(:group) { Group.at_path("ga_wdi_dc_7") }
        # let(:user) { User.named("alice") }
        # let(:other) { User.named("bob") }
    end
    context "in ancestor groups" do
      include_examples "nonadmin"
        # let(:group) { Group.at_path("ga_wdi_dc") }
        # let(:user) { User.named("alice") }
        # let(:other) { User.named("bob") }
    end
  end

  describe "admin" do
    context "in own group" do
      include_examples "admin"
        # let(:group) { Group.at_path("ga_wdi_dc_7") }
        # let(:user) { User.named("adam") }
        # let(:nonadmin) { User.named("bob") }
    end
    context "in ancestor group" do
      include_examples "nonadmin"
        # let(:group) { Group.at_path("ga_wdi_dc") }
        # let(:user) { User.named("adam") }
        # let(:other) { User.named("bob") }
    end
    context "in descendant group" do
      include_examples "nonadmin"
        # let(:group) { Group.at_path("ga_wdi_dc_7_squad-adam") }
        # let(:user) { User.named("jesse") }
        # let(:other) { User.named("john") }
    end
  end
end
