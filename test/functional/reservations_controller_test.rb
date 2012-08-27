require 'test_helper'

class ReservationsControllerTest < ActionController::TestCase
  def setup
    seed_ticket_types
  end

  test "submitting a reservation makes a reservation" do

    reservation_params = {
      name: "Fred",
      email: "fred@example.com",
phone_number: "1234",
ticket_type: "Non-sleeping, full",
participate_in_fare_pool: 0,
camping: 0,
what_can_you_help_with: "stuff",
payment_method: "gocardless"
    }
    post :create, reservation: reservation_params
    
    assert_equal 1, Reservation.count
    assert_equal "Fred", Reservation.first.name
    assert_equal "reserved", Reservation.first.state
  end
end
