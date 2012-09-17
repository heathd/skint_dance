require 'test_helper'

class DayTicketOrderTest < ActiveSupport::TestCase
  test "balance reflects ticket types when unpaid" do
    t1 = TicketType.new(price_in_pence: 100)
    t2 = TicketType.new(price_in_pence: 400)
    day_ticket_order = DayTicketOrder.new(ticket_types: [t1, t2])
    assert_equal 500, day_ticket_order.balance
  end
end
