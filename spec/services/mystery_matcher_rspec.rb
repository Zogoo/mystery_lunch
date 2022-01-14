require 'rails_helper'

RSpec.describe MysteryMatcher do
  let!(:users) { build_list(:user, 10) }
  let!(:described_object) { described_class.new(users) }

  context 'init_connection_graph' do
    subject do
      described_object.init_connection_graph
    end

    it 'should add array of partner ids' do
      users.each do |user|
        expect(user.partners.present?).to be_truthy
      end
    end
  end
end
