require 'rails_helper'

RSpec.describe 'Admin::Users', type: :request do
  let!(:user) { create(:user, password: '!QAZ2wsx') }

  before do
    user.admin!
    post user_session_path, params: { username: user.username, password: '!QAZ2wsx' }
  end

  describe 'GET /admin/users/index' do
    it 'renders a successful response' do
      get admin_users_url
      expect(response).to be_successful
    end
  end

  describe 'GET /admin/users/show' do
    it 'renders a successful response' do
      get admin_user_url(user)
      expect(response).to be_successful
    end
  end

  describe 'GET /admin/users/edit' do
    it 'render a successful response' do
      get edit_admin_user_url(user)
      expect(response).to be_successful
    end
  end

  describe 'GET /admin/users/new' do
    it 'renders a successful response' do
      get new_admin_user_url
      expect(response).to be_successful
    end
  end

  describe 'POST /admin/users/create' do
    context 'with valid parameters' do
      it 'creates a new User' do
        expect do
          post admin_users_url, params: { user: valid_attributes }
        end.to change(User, :count).by(1)
      end

      it 'redirects to the created user' do
        post admin_users_url, params: { user: valid_attributes }
        expect(response).to redirect_to(user_url(User.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new User' do
        expect do
          post admin_users_url, params: { user: invalid_attributes }
        end.to change(User, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post admin_users_url, params: { user: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe 'PATCH /admin/users/update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        {
          first_name: 'John',
          last_name: 'Snow'
        }
      end

      it 'updates the requested user' do
        patch admin_user_url(user), params: { user: new_attributes }
        user.reload
        skip('Add assertions for updated state')
      end

      it 'redirects to the user' do
        patch admin_user_url(user), params: { user: new_attributes }
        user.reload
        expect(response).to redirect_to(user_url(user))
      end
    end

    context 'with invalid parameters' do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        patch admin_user_url(user), params: { user: { username: '' } }
        expect(response).to be_successful
      end
    end
  end

  describe 'DELETE /admin/users/destroy' do
    it 'destroys the requested user' do
      expect do
        delete admin_user_url(user)
      end.to change(User, :count).by(-1)
    end

    it 'redirects to the users list' do
      delete admin_user_url(user)
      expect(response).to redirect_to(users_url)
    end
  end
end
