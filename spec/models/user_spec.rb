require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#save' do
    let(:user) { build(:user) }

    subject do
      user.save!
    end

    shared_examples 'successful creation' do
      it 'will create new user' do
        expect { subject }.to change(User, :count).from(0).to(1)
      end
    end

    shared_examples 'failed creation' do
      it 'will raise error' do
        expect { subject }.to raise_error
      end
    end

    context 'empty first and last name' do
      before do
        user.first_name = ''
        user.last_name = ''
      end

      it_behaves_like 'successful creation'
    end

    context 'empty email' do
      before do
        user.email = ''
      end

      it_behaves_like 'successful creation'
    end

    context 'wrong email format' do
      before do
        user.email = 'invalid_format'
      end

      it_behaves_like 'failed creation'
    end

    context 'empty password' do
      before do
        user.password = ''
      end

      it_behaves_like 'failed creation'
    end

    context 'less than 6 letters password' do
      before do
        user.password = '12345'
      end

      it_behaves_like 'failed creation'
    end

    context 'empty username' do
      before do
        user.username = ''
      end

      it_behaves_like 'failed creation'
    end

    context 'duplicated username' do
      let(:duplicated_user) { build(:user, username: user.username) }

      before do
        duplicated_user.save!
      end

      it_behaves_like 'failed creation'
    end
  end

  describe 'seach by attributes' do
    let(:users) { create_list(:user, 5) }

    shared_examples 'return posstive number of user' do
      it 'will return users' do
        expect(subject.count).to be > 0
      end
    end

    context 'search_by_department' do
      subject do
        described_class.by_department(users.first.department)
      end

      it_behaves_like 'return posstive number of user'
    end

    context 'search_by_first_name' do
      subject do
        described_class.by_first_name(users.first.first_name)
      end

      it_behaves_like 'return posstive number of user'
    end

    context 'search_by_last_name' do
      subject do
        described_class.by_last_name(users.first.last_name)
      end

      it_behaves_like 'return posstive number of user'
    end
  end

  describe 'custom methods' do
    let(:user) { create(:user) }

    context 'full_name' do
      it 'will genereate full name from first and last name' do
        expect(user.full_name).to eq("#{user.first_name} #{user.last_name}")
      end
    end
  end
end
