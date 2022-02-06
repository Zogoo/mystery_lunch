require 'rails_helper'

RSpec.describe 'Admin::MysteryPairs', type: :request do
  let!(:user) { create(:user, password: '!QAZ2wsx') }
  let!(:mystery_pairs) { create_list(:mystery_pair, 10) }

  before do
    user.admin!
    sign_in user
  end

  describe 'GET /index' do
    it 'returns http success' do
      get '/admin/mystery_pairs'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /show' do
    it 'returns http success' do
      get admin_mystery_pair_path(mystery_pairs.first)
      expect(response).to have_http_status(:success)
    end
  end
end
