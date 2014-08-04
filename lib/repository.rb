class Repository
  def ticket_type_by_name(name)
    TicketType.find_by_name(name)
  end

  def all_ticket_types(params)
    TicketType.find_all(params)
  end

  def create_day_ticket_order(params)
    DayTicketOrder.create(params)
  end

  def count_cancelled_reservations(resource_category)
    Reservation.cancelled.in_resource_category(resource_category).count
  end

  def count_reserved_places(resource_category)
    Reservation.reserved.in_resource_category(resource_category).count
  end

  def build_reservation(params)
    Reservation.new(params)
  end
end

