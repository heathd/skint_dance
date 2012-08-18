class ReservationManager
  def initialize(params = {})
    @available_places = params[:available_places] || self.class.default_available_places
  end

  def self.default_available_places
    {
      sleeping: 65,
      non_sleeping: 35
    }
  end

  def available_places(resource_category)
    @available_places[resource_category.to_sym]
  end

  def remaining_places(resource_category)
    [0, places_available_to_waiting_list(resource_category) - cancelled_places(resource_category)].max
  end

  def places_available_to_waiting_list(resource_category)
    available_places(resource_category) - reserved_places(resource_category)
  end

  def cancelled_places(resource_category)
    Reservation.cancelled.in_resource_category(resource_category).count
  end

  def reserved_places(resource_category)
    Reservation.reserved.in_resource_category(resource_category).count
  end

  def make_reservation(params, clock = DateTime)
    ticket_type_name = params.delete(:ticket_type)
    ticket_type = TicketType.find_by_name(ticket_type_name) or raise "Couldn't find ticket type #{ticket_type_name}"
    reservation = Reservation.new(params.merge(state: "new", reference: random_reference, ticket_type: ticket_type))
    reservation.requested_at = clock.now
    if reservation.save
      if remaining_places(ticket_type.resource_category) > 0
        reservation.reserve
        reservation.set_payment_due!(clock)
      else
        reservation.add_to_waiting_list(reservation.resource_category)
      end
      if remaining_places(:sleeping) == 0 and reservation.resource_category.to_sym == :non_sleeping
        reservation.add_to_waiting_list(:sleeping)
      end
    end
    reservation
  end

  def allocate_place_to(waiting_list_entry, clock = DateTime)
    Reservation.connection.transaction do
      if places_available_to_waiting_list(waiting_list_entry.resource_category) > 0
        waiting_list_entry.reservation.reserve(clock)
        waiting_list_entry.delete
        return true
      end
    end
  end

  def waiting_list(resource_category)
    WaitingListEntry.in_resource_category(resource_category).order("waiting_list_entries.added_at asc")
  end

  def unpaid
    Reservation.where(state: :reserved)
  end

  def find_reservation(reference)
    Reservation.find_by_reference(reference)
  end

  def random_reference
    require 'securerandom'
    reference = ::SecureRandom.urlsafe_base64(4)
    if find_reservation(reference)
      ::SecureRandom.urlsafe_base64(5)
    else
      reference
    end
  end

end