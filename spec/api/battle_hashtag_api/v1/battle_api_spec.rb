require "rails_helper"

RSpec.describe BattleHashtagAPI::V1::BattleAPI do
  describe "GET /api/v1/battles" do
    it "returns an empty array of battles" do
      get "/api/v1/battles"
      expect(response.status).to be(200)
      expect(JSON.parse(response.body).size).to be(0)
    end

    it "returns an array of battles" do
      hashtags = create_list(:hashtag, 3)
      3.times { create(:battle_with_hashtags, hashtags: hashtags) }
      get "/api/v1/battles"
      expect(response.status).to be(200)
      expect(JSON.parse(response.body).size).to be(3)
    end
  end

  describe "GET /api/v1/battles/{:id}" do
    it "fails to find the battle" do
      expect { get "/api/v1/battles/1" }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "finds a battle" do
      hashtags = create_list(:hashtag, 3)
      battle = create(:battle_with_hashtags, hashtags: hashtags)
      get "/api/v1/battles/#{battle.id}"
      expect(response.status).to be(200)
      result = JSON.parse(response.body)
      expect(result['id']).to be(battle.id)
      expect(result['hashtags'].size).to be(3)
    end
  end

  describe "GET /api/v1/battles/{:id}/summarized" do
    it "fails to find the battle" do
      expect { get "/api/v1/battles/1/summarized" }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "summarized a battle" do
      hashtags = create_list(:famous_hashtag, 3)
      battle = create(:battle_with_hashtags, hashtags: hashtags)
      get "/api/v1/battles/#{battle.id}/summarized"
      expect(response.status).to be(200)
      result = JSON.parse(response.body)
      expect(result.size).to be(3)
      result.each { |h| expect(h[1]).to be(500)}
    end
  end
end