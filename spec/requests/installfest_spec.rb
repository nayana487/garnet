require 'rails_helper'

RSpec.describe "Installfest", :type => :request do
  it "requires un-authenticated access to /users/is_registered endpoint" do
    get "/users/anything/is_registered"
    expect(response).to_not be_redirect
  end

  it "returns true (as json) for registered user" do
    get "/users/mattscilipoti/is_registered", format: :json
    expect(response).to be_success
    expect(response.body).to eq("true")
  end

  it "returns false (as json) for unregistered user" do
    get "/users/unknown_user/is_registered", format: :json
    expect(response).to be_success
    expect(response.body).to eq("false")
  end
end
