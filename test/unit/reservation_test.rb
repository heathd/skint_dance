require 'test_helper'

class ReservationTest < ActiveSupport::TestCase
  def setup
    seed_ticket_types
  end

  test "balance reflects ticket type when unpaid" do
    standard_ticket_type = TicketType.find_by_name("Full, standard")
    reservation = Reservation.new(ticket_type: standard_ticket_type)
    assert_equal standard_ticket_type.price_in_pence, reservation.balance
  end

end
