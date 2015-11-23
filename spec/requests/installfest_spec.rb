require 'rails_helper'

RSpec.describe "Installfest", :type => :request do
  it "requires un-authenticated access to /users/is_registered endpoint" do
    get "/users/is-registered"
    expect(response).to_not be_redirect
  end

  it "returns true (as json) for registered user" do
    get "/users/is-registered", format: :json, github_username: "mattscilipoti"
    expect(response).to be_success
    expect(response.body).to eq("true")
  end

  it "returns false (as json) for unregistered user" do
    get "/users/is-registered", format: :json, github_username: "unknown_user"
    expect(response).to be_success
    expect(response.body).to eq("false")
  end
end
