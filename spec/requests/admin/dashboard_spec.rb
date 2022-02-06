require 'rails_helper'

RSpec.describe 'Admin::Dashboards', type: :request do
  let!(:user) { create(:user, password: '!QAZ2wsx') }

  before do
    user.admin!
    sign_in user
  end

  describe 'GET /admin/dashboard/index' do
    it 'returns http success' do
      get admin_dashboard_index_url
      expect(response).to have_http_status(:success)
    end
  end
end
