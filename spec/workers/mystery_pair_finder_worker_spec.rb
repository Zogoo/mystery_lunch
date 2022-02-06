require 'rails_helper'

RSpec.describe MysteryPairFinderWorker, type: :worker do
  describe 'mystery pair finder worker' do
    subject do
      MysteryPairFinderWorker.perform_now
    end

    context 'when there is no previous pair data' do
      let!(:users) { create_list(:user, 10) }

      it 'will create pair data for next month' do
        expect { subject }.not_to raise_error
        expect(MysteryPair.after_at(Date.today).present?).to be(true)
      end
    end

    context 'when odd active user exist' do
      let!(:users) { create_list(:user, 11) }

      it 'will add odd user to other pair which create duplicated partner data' do
        expect { subject }.not_to raise_error
        pairs_by_group = MysteryPair.after_at(Date.today).group(:partner_id).count
        expect(pairs_by_group.values.include?(2)).to be(true)
      end
    end

    context 'when there is no active user' do
      let!(:users) { create_list(:user, 4, status: :suspended) }

      it 'will raise error' do
        expect { subject }.to raise_error(RuntimeError)
      end
    end
  end
end
