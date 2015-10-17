require 'rails_helper'

RSpec.describe Assignment do
  describe "defaults (without assigned attributes):" do
    let(:current_time) { Time.now }
    before(:each) do
      # ensure Time.now is the same when verifying as when setting defaults
      allow(Time).to receive(:now).and_return(current_time)
    end

    it "#due_date defaults to Time.now" do
      expect(subject.due_date).to eq(current_time)
    end
  end

  describe "defaults (with assigned attributes)" do
    let(:future_date) { 3.days.from_now }
    subject(:assignment) { Assignment.new(due_date: future_date) }

    it "does not override assigned #due_date" do
      expect(subject.due_date).to eq(future_date)
    end
  end

  it "has submissions status english" do
    ass = Assignment.first
    binding.pry
  end

end
