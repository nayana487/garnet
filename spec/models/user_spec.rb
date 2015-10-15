require 'rails_helper'

RSpec.describe User do
  describe "names" do
    it "#name returns name when set" do
      bob = User.new(name: "Bob", username: "bdylan" )
      expect(bob.name).to eq("Bob")
    end

    it "#name returns username when no name is set" do
      bob = User.new(name: nil, username: "bdylan" )
      expect(bob.name).to eq("bdylan")
    end
    
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

    context "with no name" do
      let(:bob) { User.new(name: nil)}

      it "#first_name returns an empty string" do
        expect(bob.first_name).to eq("")
      end

      it "#last_name returns an empty string" do
        expect(bob.last_name).to eq("")
      end
    end

  end
end
