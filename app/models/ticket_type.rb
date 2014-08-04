# encoding: UTF-8
class TicketType < ActiveRecord::Base
  validates :resource_category, :format => { :with => /\A[a-zA-Z_]+\z/ }

  def self.weekend
    where(resource_category: %w{sleeping non_sleeping}).order("price_in_pence desc")
  end

  def self.day
    where(resource_category: %w{friday_evening saturday_daytime saturday_evening sunday_daytime sunday_evening monday_daytime})
  end

  def self.find_all(types)
    types.map do |param|
      TicketType.all.find {|t| param == t.name.parameterize } or raise "Couldn't find ticket type #{param}"
    end
  end

  def formatted_price
    pounds = (price_in_pence / 100).to_i
    pence = "%02d" % (price_in_pence % 100)
    "£#{pounds}.#{pence}"
  end

  def place_available_for?(pre_reservation)
    RESERVATION_MANAGER.place_available_for?(resource_category, pre_reservation)
  end

  def waiting_list_open?
    RESERVATION_MANAGER.waiting_list_open?(resource_category)
  end

  def next_ticket_release_date
    RESERVATION_MANAGER.next_ticket_release_date(resource_category)
  end

  def option_label(pre_reservation)
    remaining_text = if place_available_for?(pre_reservation) > 0
      "place available"
    elsif waiting_list_open?
      "waiting list"
    elsif next_ticket_release_date
      "on sale #{I18n.l(next_ticket_release_date)}"
    end
    "#{description} - #{formatted_price} (#{remaining_text})"
  rescue
    description
  end
end
