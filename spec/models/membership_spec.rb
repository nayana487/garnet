require 'rails_helper'

RSpec.describe Membership do
  context "on create" do
    it "adds user as nonadmin member of all ancestor groups"
  end
  describe "nonadmin" do
    context "in own group" do
      describe "assignments" do
        it "can read all assignments"
      end
      describe "submissions" do
        it "cannot read others' submissions"
        it "cannot update others' submissions"
        it "can read own submissions"
        it "can update own submissions"
      end
      describe "events" do
        it "can read all events"
      end
      describe "attendances" do
        it "can read own attendances"
        it "cannot read others' attendances"
      end
      describe "observations" do
        it "cannot read any observations"
      end
    end
    context "in ancestor groups" do
      it "has same permissions as a nonadmin of that group"
    end
  end
  describe "admin" do
    context "in ancestor group" do
      it "has same permissions as a nonadmin of that group"
    end
    context "in descendant group" do
      it "can read all records belonging to group"
    end
    context "in own group" do
      it "can read all records belonging to group"
      it "can update group"
      it "can create child groups"
      describe "memberships" do
        it "can create memberships"
        it "can delete memberships"
      end
      describe "assignments" do
        it "can create assignments"
        it "can update all assignments"
        it "can delete all assignments"
      end
      describe "submissions" do
        it "can update all submissions"
      end
      describe "events" do
        it "can create events"
        it "can update all events"
        it "can delete all events"
      end
      describe "attendances" do
        it "can update all attendances"
      end
      describe "observations" do
        it "can create observations"
      end
    end
  end
  describe "superadmin" do
    context "in ancestor group" do
      it "has same permissions as that group's nonadmins"
    end
    context "in own group" do
      it "has same permissions as that group's admins"
    end
    context "in descendant group" do
      it "has same permissions as that group's admins"
    end
  end
end
