require 'rails_helper'

RSpec.describe MysteryMatcher do
  let!(:users) { create_list(:user, 8) }
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
    subject do
      described_object.find_mystery_pairs
    end

    before do
      described_object.init_connection_graph
    end

    context 'when there is no old data pairs exist' do
      it 'should return array of pair of users' do
        pairs = subject
        expect(pairs).to be_a(Array)
        expect(pairs.length).to be > 0
        expect(pairs.flatten.pluck(:id).compact.present?).to be true
      end

      it 'should not create duplicated pairs with different deparment' do
        pairs = subject
        pairs.each_with_object({}) do |pair, acc|
          expect(acc[pair[0][:id]].nil?).to be true
          expect(acc[pair[1][:id]].nil?).to be true
          expect(pair[0][:department] != pair[1][:department]).to be true
          acc[pair[0][:id]] = pair[0][:department]
          acc[pair[1][:id]] = pair[1][:department]
        end
      end
    end

    context 'when constant userlist' do
      let!(:users) do
        [create(:user, id: 1, department: 'operations'),
         create(:user, id: 2, department: 'operations'),
         create(:user, id: 3, department: 'risk'),
         create(:user, id: 4, department: 'management'),
         create(:user, id: 5, department: 'development and data'),
         create(:user, id: 6, department: 'marketing'),
         create(:user, id: 7, department: 'development and data'),
         create(:user, id: 8, department: 'development and data')]
      end

      it 'should return expected result' do
        expect(subject).to eq([
                                [{ 'id' => 5, 'department' => 'development and data' }, { 'id' => 1, 'department' => 'operations' }],
                                [{ 'id' => 7, 'department' => 'development and data' }, { 'id' => 2, 'department' => 'operations' }],
                                [{ 'id' => 8, 'department' => 'development and data' }, { 'id' => 3, 'department' => 'risk' }],
                                [{ 'id' => 4, 'department' => 'management' }, { 'id' => 6, 'department' => 'marketing' }]
                              ])
      end
    end

    context 'bench mark test for 100 users' do
      let!(:users) { create_list(:user, 100) }

      it 'should perform under 1 seconds' do
        expect { subject }.to perform_under(1).sec
      end
    end

    context 'bench mark test for 1000 users' do
      let!(:users) { create_list(:user, 1_000) }

      it 'should perform under 3 seconds' do
        expect { subject }.to perform_under(3).sec
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
