class DayTicketOrderTicketType < ActiveRecord::Base
  belongs_to :day_ticket_order
  belongs_to :ticket_type
end