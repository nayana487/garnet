require 'rails_helper'

RSpec.describe "Metrics", :type => :request do
  let(:url_path) { "/metrics/sandi_meter" }
  describe "sandi_meter" do
    it "requires un-authenticated access to /metrics/sandi_meter endpoint" do
      get url_path
      expect(response).to_not be_redirect
    end

    it "contains the sandi_meter html report" do
      get url_path
      expect(response.body).to match(/Sandi Metz rules/i)
    end
  end
end
