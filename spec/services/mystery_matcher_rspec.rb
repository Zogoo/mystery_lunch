require 'rails_helper'

RSpec.describe MysteryMatcher do
  let!(:users) { create_list(:user, 10) }
  let(:described_object) { described_class.new(users) }

  describe 'init_connection_graph' do
    context 'initialize connection and partners' do
      subject do
        described_object.init_connection_graph
      end

      it 'should add array of partner ids' do
        subject
        users.each do |user|
          expect(user.partners.present?).to be true
          expect(user.connection.present?).to be true
        end
      end
    end
  end

  describe 'find_mystery_pairs' do
    context 'when there is no old data pairs exist' do
      subject do
        described_object.find_mystery_pairs
      end

      before do
        described_object.init_connection_graph
      end

      it 'should return array of pair of users' do
        pairs = subject
        expect(pairs).to be_a(Array)
        expect(pairs.length).to be > 0
        expect(pairs.flatten.pluck(:id).compact.present?).to be true
      end

      it 'should not create duplicated pairs' do
        pairs = subject
        pairs.each_with_object({}) do |pair, acc|
          expect(acc[pair[0][:id]].nil?).to be true
          expect(acc[pair[1][:id]].nil?).to be true
          acc[pair[0][:id]] = pair[0][:department]
          acc[pair[1][:id]] = pair[1][:department]
        end
      end
    end
  end

  describe 'take_care_odd_user' do
    context 'when odd user left' do
      let!(:users) { create_list(:user, 9) }

      subject do
        described_object.take_care_odd_user
      end

      before do
        described_object.find_mystery_pairs
      end

      it 'will assign add odd user to other group' do
        subject
        expect(described_object.mystery_pairs.find { |pair| pair.length == 3 }.present?).to be true
      end
    end
  end
end
