# encoding: UTF-8
class TicketType < ActiveRecord::Base
  validates :resource_category, :format => { :with => /\A[a-zA-Z_]+\z/ }

  def self.options
    all.map do |type|
      [type.option_label, type.name]
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
  end
end
