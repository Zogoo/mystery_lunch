require 'rails_helper'

RSpec.describe MysteryMatcher do
  let!(:users) { create_list(:user, 10) }
  let(:described_object) { described_class.new(users) }

  context 'init_connection_graph' do
    subject do
      described_object.init_connection_graph
    end

    it 'should add array of partner ids' do
      subject
      users.each do |user|
        expect(user.partners.present?).to be true
      end
    end
  end

  context 'find_mystery_pairs' do
    subject do
      described_object.find_mystery_pairs
    end

    before do
      described_object.init_connection_graph
    end

    it 'should give pair of users' do
      expect(subject.size).to be > 0
    end
  end

  context 'take_care_odd_user' do
    let!(:users) { create_list(:user, 9) }

    subject do
      described_object.take_care_odd_user
    end

    before do
      described_object.find_mystery_pairs
    end

    it 'will assign' do
      subject
      expect(described_object.mystery_pairs.find { |pair| pair.length == 3 }.present?).to be true
    end
  end
end
