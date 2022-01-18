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
end
