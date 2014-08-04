require 'test_helper'

class ReservationTest < ActiveSupport::TestCase
  def setup
    seed_ticket_types
  end

  def pre_reservation_params
    @ref_counter ||= 0
    @ref_counter += 1
    {
      name: "Fred",
      email: "fred@example.com",
      reference: "some-ref-#{@ref_counter}",
      resource_category: "sleeping",
      expires_at: Time.zone.now + 1.hour
    }
  end

  def reservation_params(overrides = {})
    {
      state: "new",
      name: "Fred", 
      email: "fred@example.com",
      phone_number: "123",
      what_can_you_help_with: "chopping veg",
      payment_method: "paypal",
      ticket_type: TicketType.find_by_name("Fri-Sun, standard"),
      requested_at: Time.zone.now
    }.merge(overrides)
  end

  test "balance reflects ticket type when unpaid" do
    standard_ticket_type = TicketType.find_by_name("Fri-Sun, standard")
    reservation = Reservation.new(ticket_type: standard_ticket_type)
    assert_equal standard_ticket_type.price_in_pence, reservation.balance
  end

  test "invalid if no reference" do
    reservation = Reservation.new
    refute reservation.valid?
    assert reservation.errors[:reference].any?, "must have an error about the reference"
  end

  test "invalid if reference does not match a pre-reservation" do
    reservation = Reservation.new
    reservation.reference = 'some-ref'
    refute reservation.valid?
    assert reservation.errors[:reference].any?, "must have an error about the reference"
    assert_match /no matching pre-reservation/, reservation.errors[:reference].first
  end

  test "valid if reference matches a pre-reservation" do
    pre_reservation = PreReservation.create!(pre_reservation_params)
    reservation = Reservation.create(reservation_params.merge(reference: pre_reservation.reference))
    assert reservation.valid?, reservation.errors.full_messages.to_sentence
  end

  test "invalid if pre-reservation used for another reservation" do
    pre_reservation1 = PreReservation.create!(pre_reservation_params)
    reservation1 = Reservation.create!(reservation_params(reference: pre_reservation1.reference))
    reservation2 = Reservation.create(reservation_params(reference: pre_reservation1.reference))
    refute reservation2.valid?
    assert reservation2.errors[:reference].any?, "must have an error about the reference"
    assert_match /already used/, reservation2.errors[:reference].first
  end

end
