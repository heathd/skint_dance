require 'test_helper'
require_relative "../../lib/reservation_manager"

class ReservationManagerTest < ActiveSupport::TestCase
  def reservation_params(overrides = {})
    {
      name: "Fred", 
      email: "fred@example.com",
      phone_number: "123",
      what_can_you_help_with: "chopping veg",
      payment_method: "paypal",
      ticket_type: "Fri-Sun, standard"
    }.merge(overrides)
  end

  def fixed_clock(fixed_at)
    OpenStruct.new(now: DateTime.parse(fixed_at))
  end

  def setup
    seed_ticket_types
  end

  test "default reservation manager has 0 sleeping places and 0 non-sleeping places before 7th august" do
    @reservation_manager = ReservationManager.new(clock: fixed_clock('2013-08-06'))
    assert_equal 0, @reservation_manager.available_places(:sleeping)
    assert_equal 0, @reservation_manager.available_places(:non_sleeping)
  end

  test "default reservation manager has 35 sleeping places and 15 non-sleeping places from 7th august" do
    @reservation_manager = ReservationManager.new(clock: fixed_clock('2013-08-07'))
    assert_equal 35, @reservation_manager.available_places(:sleeping)
    assert_equal 15, @reservation_manager.available_places(:non_sleeping)
  end

  test "default reservation manager has 65 sleeping places and 35 non-sleeping places from 28th august" do
    @reservation_manager = ReservationManager.new(clock: fixed_clock('2013-08-28'))
    assert_equal 65, @reservation_manager.available_places(:sleeping)
    assert_equal 35, @reservation_manager.available_places(:non_sleeping)
  end

  test "default reservation manager has day tickets" do
    @reservation_manager = ReservationManager.new
    assert_equal 80, @reservation_manager.available_places(:friday_evening)
    assert_equal 30, @reservation_manager.available_places(:saturday_daytime)
    assert_equal 80, @reservation_manager.available_places(:saturday_evening)
    assert_equal 30, @reservation_manager.available_places(:sunday_daytime)
  end

  test "can specify available places in constructor" do
    r = ReservationManager.new(available_places: {sleeping: 1, non_sleeping: 2})
    assert_equal 1, r.available_places(:sleeping)
    assert_equal 2, r.available_places(:non_sleeping)
  end

  test "remaining places match available places when none used" do
    @reservation_manager = ReservationManager.new
    assert_equal @reservation_manager.remaining_places(:sleeping), @reservation_manager.available_places(:sleeping)
    assert_equal @reservation_manager.remaining_places(:non_sleeping), @reservation_manager.available_places(:non_sleeping)
  end
  
  test "#random_reference finds a free random reference" do
    assert_match /^[a-zA-Z0-9=_-]{4,10}$/, ReservationManager.new.random_reference
  end

  test "make_reservation creates a reserved reservation with a reference number " do
    reservation = ReservationManager.new(clock: fixed_clock("2013-08-07")).make_reservation(reservation_params)
    assert reservation.valid?
    assert_equal 'reserved', reservation.state
    refute reservation.reference.blank?
  end

  test "make_reservation uses the provided clock to set requested_at" do
    clock = OpenStruct.new(now: DateTime.parse("2011-01-01 00:00"))
    reservation = ReservationManager.new.make_reservation(reservation_params, clock)
    assert_equal clock.now, reservation.requested_at
  end

  test "make_reservation uses the provided clock to set payment_due date" do
    clock = fixed_clock("2013-08-27")
    reservation = ReservationManager.new(clock: clock).make_reservation(reservation_params)
    assert_equal clock.now + 1.week, reservation.payment_due
  end

  test "making a valid reservation decrements the available places for that resource category, but not other categories" do
    reservation_manager = ReservationManager.new(clock: fixed_clock("2013-08-27"))
    assert_difference "reservation_manager.remaining_places(:non_sleeping)", 0 do
      assert_difference "reservation_manager.remaining_places(:sleeping)", -1 do
        reservation_manager.make_reservation(reservation_params(ticket_type: "Fri-Sun, standard"))
      end
    end
  end

  test "making an invalid reservation does not decrement the available places for that resource category" do
    reservation_manager = ReservationManager.new
    ticket_type = TicketType.find_by_name("Fri-Sun, standard")
    assert_difference "reservation_manager.remaining_places(:sleeping)", 0 do
      reservation_manager.make_reservation(reservation_params(ticket_type: "Fri-Sun, standard", email: "invalid@email@address"))
    end
  end

  test "making a valid reservation when only one place left succeeds" do
    reservation_manager = ReservationManager.new(available_places: {sleeping: 1, non_sleeping: 0})
    reservation = reservation_manager.make_reservation(reservation_params)
    assert reservation.valid?
    assert_equal "reserved", reservation.state
    assert_equal 0, reservation_manager.remaining_places(reservation.resource_category)
  end

  test "waiting list is closed when there will be a future ticket issue for the resource category" do
    reservation_manager = ReservationManager.new(
      availability_schedule: {
        "2013-01-01" => {sleeping: 0, non_sleeping: 0},
        "2013-01-02" => {sleeping: 1}
      })
    refute reservation_manager.waiting_list_open?(:sleeping, fixed_clock("2013-01-01"))
    assert reservation_manager.waiting_list_open?(:non_sleeping, fixed_clock("2013-01-01"))
    assert reservation_manager.waiting_list_open?(:sleeping, fixed_clock("2013-01-02"))
  end

  test "can indicate next tickets available" do
    reservation_manager = ReservationManager.new(
      availability_schedule: {
        "2013-01-01" => {sleeping: 0, non_sleeping: 0},
        "2013-01-02" => {sleeping: 1}
      })
    assert_equal Date.parse("2013-01-02"), reservation_manager.next_ticket_release_date(:sleeping, fixed_clock("2013-01-01"))
    assert_nil reservation_manager.next_ticket_release_date(:non_sleeping, fixed_clock("2013-01-01"))
    assert_nil reservation_manager.next_ticket_release_date(:sleeping, fixed_clock("2013-01-02"))
  end

  test "making a valid reservation when no places left adds the place to the waiting list" do
    reservation_manager = ReservationManager.new(available_places: {sleeping: 0, non_sleeping: 0})
    reservation = reservation_manager.make_reservation(reservation_params)
    assert reservation.valid?
    assert_equal "waiting_list", reservation.state
    assert_equal [reservation], reservation_manager.waiting_list(reservation.resource_category).map(&:reservation)
  end

  test "cancelling a reserved place does not release a place to general signups" do
    reservation_manager = ReservationManager.new
    reservation = reservation_manager.make_reservation(reservation_params)
    assert_no_difference "reservation_manager.remaining_places(reservation.resource_category)" do
      reservation.cancel
    end
  end

  test "cancelling a reserved place does release the place to the waiting list" do
    reservation_manager = ReservationManager.new(clock: fixed_clock("2013-08-27"))
    reservation = reservation_manager.make_reservation(reservation_params)
    assert_difference "reservation_manager.places_available_to_waiting_list(reservation.resource_category)", 1 do
      reservation.cancel
    end
  end

  test "waiting_list returns places in reverse order of request" do
    reservation_manager = ReservationManager.new(available_places: {sleeping: 0, non_sleeping: 0})
    reservations = [
      reservation_manager.make_reservation(reservation_params, fixed_clock('2011-01-01')),
      reservation_manager.make_reservation(reservation_params, fixed_clock('2011-01-02')),
    ]
    assert_equal reservations, reservation_manager.waiting_list(:sleeping).map(&:reservation)
  end

  test "waiting_list ignores cancelled places" do
    reservation_manager = ReservationManager.new(available_places: {sleeping: 0, non_sleeping: 0})
    reservation_manager
      .make_reservation(reservation_params)
      .cancel
    assert_equal [], reservation_manager.waiting_list(:sleeping)
  end

  test "waiting_list skips places which have reserved successfully" do
    reservation_manager = ReservationManager.new(available_places: {sleeping: 1, non_sleeping: 0})
    reservations = [
      reservation_manager.make_reservation(reservation_params, fixed_clock('2011-01-01')),
      reservation_manager.make_reservation(reservation_params, fixed_clock('2011-01-02')),
    ]
    assert_equal reservations[1..1], reservation_manager.waiting_list(:sleeping).map(&:reservation)
  end

  test "waiting_list for sleeping places includes people who reserved successfully for non_sleeping places" do
    reservation_manager = ReservationManager.new(available_places: {sleeping: 1, non_sleeping: 1})
    reservations = [
      reservation_manager.make_reservation(reservation_params(ticket_type: "Fri-Sun, standard"), fixed_clock('2011-01-01')),
      reservation_manager.make_reservation(reservation_params(ticket_type: "Non-sleeping, Fri-Sun, full"), fixed_clock('2011-01-02')),
      reservation_manager.make_reservation(reservation_params(ticket_type: "Fri-Sun, standard"), fixed_clock('2011-01-03'))
    ]
    assert_equal reservations[1..2], reservation_manager.waiting_list(:sleeping).map(&:reservation)
    assert_equal "reserved", reservations[1].reload.state
  end

  test "waiting_list for sleeping places includes people who are waiting for non_sleeping places" do
    reservation_manager = ReservationManager.new(available_places: {sleeping: 1, non_sleeping: 0})
    reservations = [
      reservation_manager.make_reservation(reservation_params(ticket_type: "Fri-Sun, standard"), fixed_clock('2011-01-01')),
      reservation_manager.make_reservation(reservation_params(ticket_type: "Non-sleeping, Fri-Sun, full"), fixed_clock('2011-01-02')),
    ]
    assert_equal reservations[1..1], reservation_manager.waiting_list(:sleeping).map(&:reservation)
  end

  test "waiting_list for sleeping places excludes people who reserved successfully for non_sleeping places before sleeping places ran out" do
    reservation_manager = ReservationManager.new(available_places: {sleeping: 1, non_sleeping: 20})
    reservations = [
      reservation_manager.make_reservation(reservation_params(ticket_type: "Non-sleeping, Fri-Sun, full"), fixed_clock('2011-01-01')),
      reservation_manager.make_reservation(reservation_params(ticket_type: "Fri-Sun, standard"), fixed_clock('2011-01-02')),
      reservation_manager.make_reservation(reservation_params(ticket_type: "Non-sleeping, Fri-Sun, full"), fixed_clock('2011-01-03'))
    ]
    assert_equal reservations[2..2], reservation_manager.waiting_list(:sleeping).map(&:reservation)
  end

  test "can allocate a place to a waiting list entry" do
    reservation_manager = ReservationManager.new(available_places: {sleeping: 1})
    reserved = reservation_manager.make_reservation(reservation_params(ticket_type: "Fri-Sun, standard"), fixed_clock('2011-01-01'))
    waiting = reservation_manager.make_reservation(reservation_params(ticket_type: "Fri-Sun, standard"), fixed_clock('2011-01-02'))
    reserved.cancel
    assert reservation_manager.allocate_place_to(waiting.waiting_list_entries.first, fixed_clock('2011-01-04'))
    assert_equal 0, WaitingListEntry.count
    waiting.reload
    assert_equal "reserved", waiting.state
    assert_equal DateTime.parse('2011-01-04') + 1.week, waiting.payment_due
  end
end
