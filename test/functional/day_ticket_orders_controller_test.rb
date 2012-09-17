require 'test_helper'

class DayTicketOrdersControllerTest < ActionController::TestCase
  setup do
    TicketType.create(name: "Friday", description: "Friday day", price_in_pence: 100, resource_category: "friday_evening")
  end

  test "ordering a day ticket creates the day ticket record" do
    post :create, day_ticket_order: {
      name: "David",
      email: "david@example.com",
      phone_number: "123", 
      what_can_you_help_with: "chopping veg",
      camping: false,
      ticket_types: {friday: 1}
    }

    assert_equal 1, DayTicketOrder.count
    order = DayTicketOrder.first
    assert_equal "David", order.name
    assert_equal "david@example.com", order.email
    assert_equal "123", order.phone_number
    assert_equal "chopping veg", order.what_can_you_help_with
    assert_equal false, order.camping
    assert_equal [TicketType.first], order.ticket_types
    assert_redirected_to day_ticket_order_path(order)
  end

  test "ordering a day ticket sends an acknowledgement email" do
    post :create, day_ticket_order: {
      name: "David",
      email: "david@example.com",
      phone_number: "123", 
      what_can_you_help_with: "chopping veg",
      camping: false,
      ticket_types: {friday: 1}
    }
    email = ActionMailer::Base.deliveries.last
 
    created_order = DayTicketOrder.first
    assert_equal "[TEST] Skint day ticket order acknowledgement", email.subject
    assert_equal 'david@example.com', email.to[0]
    assert_match(/Hi David/, email.body.to_s)
    assert_match(%r{#{day_ticket_order_path(created_order)}}, email.body.to_s)
    puts email.body.to_s
  end
end