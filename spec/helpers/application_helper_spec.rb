require "rails_helper"

RSpec.describe ApplicationHelper do
  describe "#color_of" do
    # These are defined using the HSL color spectrum
    let(:red){ 0 }
    let(:yellow){ 60 }
    let(:green){ 120 }
    let(:orange){ 48 }
    context "when passed a submission or attendance" do
      before(:all) do
        u = User.create(name: "test")
        c = Cohort.create
        @sub = c.add_member(u).submissions.create
        @options = {type: "int"}
      end
      it "returns empty string for unmarked" do
        @sub.update!(status: "unmarked")
        expect(color_of(@sub, @options)).to eq("")
      end
      it "returns red for missing" do
        @sub.update!(status: "missing")
        expect(color_of(@sub, @options)).to eq(red)
      end
      it "returns yellow for incomplete" do
        @sub.update!(status: "incomplete")
        expect(color_of(@sub, @options)).to eq(yellow)
      end
      it "returns green for complete" do
        @sub.update!(status: "complete")
        expect(color_of(@sub, @options)).to eq(green)
      end
    end
    context "when passed a number of tardies" do
      before(:all) do
        @options = {type: "int", green: 0, red: 5}
      end
      it "returns green for 0" do
        expect(color_of(0, @options)).to eq(green)
      end
      it "returns red for 5" do
        expect(color_of(5, @options)).to eq(red)
      end
    end
    context "when passed a percent" do
      before(:all) do
        @options = {type: "int"}
      end
      it "returns green for 100" do
        expect(color_of(100, @options)).to eq(green)
      end
      it "returns yellow for 50" do
        expect(color_of(50, @options)).to eq(yellow)
      end
      it "returns red for 0" do
        expect(color_of(0, @options)).to eq(red)
      end
    end
    context "when passed a percent for submissions or attendance" do
      before(:all) do
        @options = {type: "int", green: 100, red: 80}
      end
      it "returns green for 100%" do
        expect(color_of(100, @options)).to eq(green)
      end
      it "returns yellow for 90%" do
        expect(color_of(90, @options)).to eq(yellow)
      end
      it "returns red for 80%" do
        expect(color_of(80, @options)).to eq(red)
      end
      it "returns red for 70%" do
        expect(color_of(70, @options)).to eq(red)
      end
    end
    context "when passed an average observation" do
      before(:all) do
        @options = {type: "int", green: Observation.statuses[:green], red: Observation.statuses[:red]}
        @cohort = Cohort.create
        @user = User.create(name: "obztest", username: "obztest")
        @m = @cohort.add_member(@user)
      end
      it "returns orange for 2 red, 2 yellow, 1 green observation" do
        {red: 2, yellow: 2, green: 1}.each do |color, quantity|
          quantity.times do
            @m.observations.create!(status: color, body: "Test")
          end
        end
        expect(color_of(@m.average_observations, @options)).to eq(orange)
      end
    end
  end
end
