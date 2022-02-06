require 'rails_helper'

RSpec.describe 'Admin::Users', type: :request do
  let!(:user) { create(:user, password: '!QAZ2wsx') }

  before do
    user.admin!
    sign_in user
  end

  describe 'GET /admin/users/index' do
    it 'renders a successful response' do
      get admin_users_url
      expect(response).to be_successful
    end

    context 'when normal user try to access admin page' do
      before do
        user.user!
      end

      it 'will redirect to user page and show flash error message' do
        get admin_users_url
        expect(response).to redirect_to(users_path)
        expect(flash[:alert]).to eq(I18n.t('common.errors.unauthorized_request'))
      end
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
    let(:user_photo) do
      fixture_path = Rails.root.join("spec/fixtures/user_photos/avatar#{(1..8).to_a.sample}.png")
      Rack::Test::UploadedFile.new(fixture_path, 'image/jpg')
    end
    let(:valid_attributes) do
      {
        photo: user_photo,
        username: 'john',
        department: ['operations', 'sales', 'marketing', 'risk', 'management', 'finance', 'HR', 'development and data'].sample,
        first_name: 'john',
        last_name: 'doe',
        email: Faker::Internet.email,
        password: SecureRandom.hex(5)
      }
    end
    let(:invalid_attributes) { valid_attributes.merge(department: 'some_other_department') }

    context 'with valid parameters' do
      it 'creates a new User' do
        expect do
          post admin_users_url, params: { user: valid_attributes }
        end.to change(User, :count).by(1)
      end

      it 'redirects to the created user' do
        post admin_users_url, params: { user: valid_attributes }
        expect(response).to redirect_to(admin_users_url)
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
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH /admin/users/update' do
    let(:new_attributes) do
      {
        first_name: 'John',
        last_name: 'Snow'
      }
    end

    context 'with valid parameters' do
      it 'updates the requested user' do
        patch admin_user_url(user), params: { user: new_attributes }
        user.reload
        expect(user.first_name).to eq('John')
        expect(user.last_name).to eq('Snow')
      end

      it 'redirects to the user' do
        patch admin_user_url(user), params: { user: new_attributes }
        expect(response).to redirect_to(admin_user_url(user))
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) do
        new_attributes.merge(username: '')
      end
      it "renders a successful response (i.e. to display the 'edit' template)" do
        patch admin_user_url(user), params: { user: invalid_attributes }
        expect(response).to redirect_to(admin_user_url(user))
      end
    end
  end

  describe 'DELETE /admin/users/destroy' do
    context 'when admin destroy user' do
      it 'will suspend user' do
        expect do
          delete admin_user_url(user)
        end.to change(User, :count).by(0)
        user.reload
        expect(user.suspended!).to eq(true)
      end

      it 'redirects to the users list' do
        delete admin_user_url(user)
        expect(response).to redirect_to(users_url)
      end
    end
  end
end
