require 'rails_helper'

RSpec.describe User do
  describe "names" do
    context "with two words in the name" do
      let(:bob) { User.new(name: "Bob Smith")}

      it "#first_name returns the first word in the name" do
        expect(bob.first_name).to eq("Bob")
      end

      it "#last_name returns the last word in the name" do
        expect(bob.last_name).to eq("Smith")
      end
    end

    context "with 3+ words in the name" do
      let(:charlie) { User.new(name: "Charlie J. Smith")}

      it "#first_name returns the first word in the name" do
        expect(charlie.first_name).to eq("Charlie")
      end

      it "#last_name returns the last word in the name name" do
        expect(charlie.last_name).to eq("Smith")
      end
    end

    context "with improper capitalization" do
      let(:david) { User.new(name: "david smith")}

      it "#first_name returns the first word in the name" do
        expect(david.first_name).to eq("David")
      end

      it "#last_name returns the last word in the name name" do
        expect(david.last_name).to eq("Smith")
      end
    end


  end
end
