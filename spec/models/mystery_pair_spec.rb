require 'rails_helper'

RSpec.describe MysteryPair, type: :model do
  describe 'self join table' do
    let(:mystery_pair) { create(:mystery_pair) }

    context 'user and partner methods' do
      it 'will return user model' do
        expect(mystery_pair.user).to be_a(User)
        expect(mystery_pair.partner).to be_a(User)
      end
    end
  end

  describe 'mystery pair cancelation' do
    let(:mystery_pairs) { create_list(:mystery_pair, 10, lunch_date: 1.month.from_now) }
    let(:test_user) { mystery_pairs.first.user }

    context 'when suspend one user' do
      subject do
        described_class.remove_user(test_user)
      end

      it 'will remove all future pair data' do
        expect { subject }.not_to raise_error
        expect(MysteryPair.after_at(Date.today).by_user(test_user).present?).to eq(false)
      end

      it 'will add remaining partner to other pair' do
        partners = MysteryPair.after_at(Date.today).where(user_id: test_user.id).pluck(:partner_id)
        subject
        new_partners = MysteryPair.where(user_id: partners).pluck(:partner_id)
        expect(new_partners.present?).to eq(true)
        expect(new_partners.include?(test_user.id)).to eq(false)
      end
    end
  end

  describe 'add user to existing pair' do
    let!(:mystery_pairs) { create_list(:mystery_pair, 10, lunch_date: 1.month.from_now) }
    let(:new_user) { create(:user, department: 'risk') }

    context 'when add new user to existing pair' do
      subject do
        described_class.add_user(new_user)
      end

      it 'will add 4 more pair data' do
        expect { subject }.to change(MysteryPair, :count).by(4)
      end

      it 'will add user to existing pair' do
        expect { subject }.not_to raise_error
        expect(MysteryPair.after_at(Date.today).by_user(new_user).present?).to eq(true)
      end
    end
  end
end
