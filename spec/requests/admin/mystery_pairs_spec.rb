require 'rails_helper'

RSpec.describe 'Admin::MysteryPairs', type: :request do
  let!(:user) { create(:user, password: '!QAZ2wsx') }

  before do
    user.admin!
    sign_in user
  end

  describe 'GET /index' do
    it 'returns http success' do
      get '/admin/mystery_pairs/index'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /show' do
    it 'returns http success' do
      get '/admin/mystery_pairs/show'
      expect(response).to have_http_status(:success)
    end
  end
end
