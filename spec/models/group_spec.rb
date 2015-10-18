require 'rails_helper'

RSpec.describe Group do
  before(:all) do
    Group.destroy_all
    Assignment.destroy_all
    groups = {
      "a1": {
        "a2": {
          "a3": {
          },
          "b3": {
          }
        },
        "b2": {
        }
      },
      "b1": {
        "c2": {
        },
        "d2": {
        }
      }
    }
    @base = Group.create!(title: "ga")
    @base.create_descendants(groups, :title)
  end
  describe "path" do
    it "is joining of ancestor group titles with underscore" do
      b2 = Group.find_by(title: "b2")
      expect(b2.path).to eq("ga_a1_b2")
    end
    context "on updating of ancestor's title" do
      it "is also updated" do
        newtitle = "foo"
        Group.find_by(title: "a1").update(title: newtitle)
        b2 = Group.find_by(title: "b2")
        expect(b2.path).to eq("ga_foo_b2")
      end
    end
  end
  describe "family attribute getter" do
    before(:all) do
      @b1 = Group.find_by(title: "b1")
      @a2 = Group.find_by(title: "a2")
      @a3 = Group.find_by(title: "a3")
      @d2 = Group.find_by(title: "d2")
      @b1_1 = @b1.assignments.create(title: "B1_1")
      @a2_1 = @a2.assignments.create(title: "A2_1")
      @a2_2 = @a2.assignments.create(title: "A2_2")
      @a3_3 = @a3.assignments.create(title: "A3_1")
      @d2_1 = @d2.assignments.create(title: "D2_1")
    end
    describe "#descendants_attr" do
      it "retrieves a collection of attribute values for self and subgroups" do
        expect(@base.descendants_attr("assignments")).to match_array([@a2_1, @a2_2, @a3_3, @d2_1, @b1_1])
      end
    end
    describe "#ancestors_attr" do
      it "retrieves a collection of attribute values for self and ancestors" do
        expect(@d2.ancestors_attr("assignments")).to match_array([@d2_1, @b1_1])
      end
    end
  end
  context "on destroy" do
    before(:all) do
      @base.destroy!
    end
    it "also destroys all descendants" do
      expect(Group.all.count).to eq(0)
    end
    it "does not also destroy descendants' attached has_manys" do
      expect(Assignment.all.count).not_to eq(0)
    end
  end
end
