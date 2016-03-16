require "rails_helper"

RSpec.describe Observation do
  before(:all) do
    @cohort = Cohort.create
    @user = User.create(name: "test", username: "obzmodeltest")
    @membership = @cohort.add_member(@user)
  end
  it "has a default status of 0" do
    o = @membership.observations.create(body: "test")
    expect(o.read_attribute("status")).to be(0)
  end
  it "changes nil statuses to 0" do
    o = @membership.observations.create(body: "test", status: "green")
    o.update(status: nil)
    expect(o.read_attribute("status")).to be(0)
  end
end
