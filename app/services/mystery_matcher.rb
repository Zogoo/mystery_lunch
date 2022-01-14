# Graph based matching logic.
# Each user become one of node for graph and parter data will be connection of nodes.
# Main thing of this logic is selecting user who has minimum connection from other users.
# That will allow to have more chance to select all users for partner.
# For example:
# A, B, C users has following connections excluding old partner and same deparment
#       A
#     //  \\
#    B  -  C
# This logic convert those connections to [{id: A, connection: 2}, {id: B, connection: 3}, {id: C, connection: 4}]
# From this connection data it will choose A - B first decrease all connections from others that already selected.
class MysteryMatcher
  attr_accessor :users, :old_partners
  attr_reader :mystery_pairs

  def initialize(users, old_partners = {})
    self.users = users
    self.old_partners = old_partners
    @mystery_pairs = []
  end

  def user_by_min_connection(partial_users = users)
    partial_users.min_by { |user| user.connection.zero? ? Float::INFINITY : user.connection }
  end

  def find_user_by_id(search_id)
    users.find { |user| user.id == search_id }
  end

  def next_non_selected_user(user_ids)
    users.find { |user| user_ids.include?(user.id) && !user.selected }
  end

  def non_selected_users
    users.reject(&:selected)
  end

  def update_old_partners(partners)
    partners.each do |pair|
      old_partners[pair[0]] = pair[1]
      old_partners[pair[1]] = pair[0]
    end
  end

  def init_connection_graph
    users.each_with_index do |user, indx|
      user.selected = false
      users[(indx + 1)..(users.length - 1)].each do |partner|
        user_id = user.id
        partner_id = partner.id
        next if old_partners[user_id] == partner_id || user.department == partner.department

        add_partner(user, partner_id)
        increase_connection(user)
        add_partner(partner, user_id)
        increase_connection(partner)
      end
    end
  end

  def find_mystery_pairs
    # Prepare user connection graph data
    init_connection_graph
    user_by_min_conn = user_by_min_connection

    loop do
      next if user_by_min_conn.selected

      next_partner = next_non_selected_user(user_by_min_conn.partners)
      break if next_partner.nil?

      user_by_min_conn.selected = true
      next_partner.selected = true

      @mystery_pairs.push([user_by_min_conn.attributes.slice(:id, :department),
                           next_partner.attributes.slice(:id, :department)])

      next_partner.partners.each do |partner_id|
        partner = find_user_by_id(partner_id)
        next if partner.selected

        partner.connection -= 1
      end

      # Take next user who has min connection and not selected yet
      user_by_min_conn = user_by_min_connection(non_selected_users)
      break if user_by_min_conn.nil?
    end

    # Old partner data
    update_old_partners(@mystery_pairs)

    @mystery_pairs
  end

  def take_care_odd_user
    odd_user = non_selected_users[0]
    return if odd_user.nil?

    mystery_pair = mystery_pairs.find do |partners|
      partners[0][:deparment] != odd_user[:deparment] && partners[1][:deparment] != odd_user[:deparment]
    end

    raise 'Odd user cannot be added to any pairs' if mystery_pair.nil?

    mystery_pair.push(odd_user.attributes.slice(:id, :department))
  end

  private

  def add_partner(user, partner_id)
    user.partners = [] if user.partners.nil?
    user.partners.push(partner_id)
  end

  def increase_connection(user)
    user.connection = 0 if user.connection.nil?
    user.connection += 1
  end
end
