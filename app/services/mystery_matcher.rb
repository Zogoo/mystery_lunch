# Graph based matching logic.
# Each user become one of node for graph and parter data will be connection of nodes.
# Main thing of this logic is selecting user who has minimum connection from other users.
# That will allow to have more chance to select all users for partner.
# For example:
# A, B, C users has following connections excluding old partner and same department
#       A
#     //  \\
#    B  -  C
# This logic convert those connections to [{id: A, connection: 2}, {id: B, connection: 3}, {id: C, connection: 4}]
# From this connection data it will choose A - B first decrease all connections from others that already selected.
class MysteryMatcher
  attr_accessor :users, :old_partners, :matching_data
  attr_reader :mystery_pairs

  def initialize(users, old_partners = {})
    self.users = users
    self.old_partners = old_partners
    self.matching_data = {}
    @mystery_pairs = []
  end

  def user_by_min_connection(partial_users = matching_data)
    partial_users.min_by { |_, user| user[:connection].zero? ? Float::INFINITY : user[:connection] }
  end

  def find_user_by_id(user_id)
    matching_data[user_id]
  end

  def non_selected_users
    matching_data.reject { |_, v| v[:selected] }
  end

  def update_old_partners(partners)
    partners.each do |pair|
      old_partners[pair[0]] = [] if old_partners[pair[0]].nil?
      old_partners[pair[1]] = [] if old_partners[pair[1]].nil?
      old_partners[pair[0]].push(pair[1])
      old_partners[pair[1]].push(pair[0])
    end
  end

  def init_connection_graph
    users.each_with_index do |user, indx|
      matching_data[user.id] = {} if matching_data[user.id].nil?
      matching_data[user.id][:id] = user.id
      matching_data[user.id][:selected] = false
      matching_data[user.id][:department] = user.department
      users[(indx + 1)..(users.length - 1)].each do |partner|
        user_id = user.id
        partner_id = partner.id
        # TODO: Introducing O(m) complexity in here
        # Use better data structure which not require Array#include?
        next if old_partners[user_id]&.include?(partner_id) || user.department == partner.department

        add_partner(user_id, partner_id)
        increase_connection(user_id)
        add_partner(partner_id, user_id)
        increase_connection(partner_id)
      end
    end
    matching_data
  end

  def find_mystery_pairs
    # Prepare user connection graph data
    init_connection_graph
    user_id, users_data = user_by_min_connection

    loop do
      next if users_data[:selected]

      next_partner_id = users_data[:partners].find { |u| !matching_data[u][:selected] }
      break if next_partner_id.nil?

      next_partner = matching_data[next_partner_id]

      users_data[:selected] = true
      next_partner[:selected] = true
      @mystery_pairs.push([users_data.slice(:id, :department),
                           next_partner.slice(:id, :department)])

      next_partner[:partners].each do |partner_id|
        partner = find_user_by_id(partner_id)
        next if partner[:selected]

        partner[:connection] -= 1
      end

      # Take next user who has min connection and not selected yet
      user_id, users_data = user_by_min_connection(non_selected_users)
      break if user_id.nil?
    end

    # Old partner data
    update_old_partners(@mystery_pairs)

    @mystery_pairs
  end

  def take_care_odd_user
    odd_user = non_selected_users&.first&.[](1)
    return if odd_user.nil?

    mystery_pair = mystery_pairs.find do |partners|
      partners[0][:department] != odd_user[:department] && partners[1][:department] != odd_user[:department]
    end

    raise 'Odd user could not be added to any pairs' if mystery_pair.nil?

    mystery_pair.push(odd_user.slice(:id, :department))
  end

  private

  def add_partner(user_id, partner_id)
    matching_data[user_id] = {} if matching_data[user_id].nil?
    matching_data[user_id][:partners] = [] if matching_data[user_id][:partners].nil?
    matching_data[user_id][:partners].push(partner_id)
  end

  def increase_connection(user_id)
    matching_data[user_id] = {} if matching_data[user_id].nil?
    matching_data[user_id][:connection] = 0 if matching_data[user_id][:connection].nil?
    matching_data[user_id][:connection] += 1
  end
end
