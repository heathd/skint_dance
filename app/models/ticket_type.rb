# encoding: UTF-8
class TicketType < ActiveRecord::Base
  validates :resource_category, :format => { :with => /\A[a-zA-Z_]+\z/ }

  def self.weekend
    where(resource_category: %w{sleeping non_sleeping})
  end

  def self.day
    where(resource_category: %w{friday_evening saturday_daytime saturday_evening sunday_daytime})
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

  def option_label
    remaining_places = RESERVATION_MANAGER.remaining_places(resource_category)
    remaining_text = if remaining_places > 0
      "#{remaining_places} left"
    else
      "waiting list"
    end
    "#{description} - #{formatted_price} (#{remaining_text})"
  rescue
    description
  end
end
