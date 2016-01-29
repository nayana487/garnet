require 'rails_helper'

RSpec.describe 'Github' do
  before {skip}
  it "has an access token" do
    g = Github.new(nil, ENV['token'])
    expect(g.token).to be
  end
  it "has a repo" do
    g = Github.new(nil, ENV['token'])
    repo = g.repo("ga-dc/js-calculator")
    expect(repo).to be
  end
  it "has issues" do
    g = Github.new(nil, ENV['token'])
    issues = g.issues("ga-dc/js-calculator")
    expect(issues).to be
  end
end
