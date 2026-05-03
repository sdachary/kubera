require "rails_helper"

RSpec.describe "Api::V1::DividendSip", type: :request do
  let(:user) { users(:family_admin) }
  let(:token) { Doorkeeper::AccessToken.create!(resource_owner_id: user.id, scopes: "read") }
  let(:headers) { { "Authorization" => "Bearer #{token.token}" } }

  describe "GET /api/v1/dividend_sip/suggest" do
    it "returns suggestions and timeline" do
      get "/api/v1/dividend_sip/suggest", params: { monthly_investment: 5000, target_income: 1000 }, headers: headers

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json).to have_key("suggestions")
      expect(json).to have_key("timeline")
      expect(json["suggestions"].length).to eq(5)
      expect(json["timeline"]["months"]).to be > 0
    end
  end
end
