class ReservationManager
  def initialize(params = {})
    @clock = params[:clock] || DateTime
    if params[:availability_schedule]
      @availability_schedule = params[:availability_schedule]
    elsif params[:available_places]
      @availability_schedule = {nil => params[:available_places]}
    else
      @availability_schedule = self.class.availability_schedule
    end
  end

  def self.availability_schedule
    {
      nil => {
        friday_evening: 80,
        saturday_daytime: 30,
        saturday_evening: 80,
        sunday_daytime: 30
      },
      '2013-08-19 12:00' => {
        sleeping: 35,
        non_sleeping: 15,
        friday_evening: 80,
        saturday_daytime: 30,
        saturday_evening: 80,
        sunday_daytime: 30        
      },
      '2013-08-28 12:00' => {
        sleeping: 65,
        non_sleeping: 35,
        friday_evening: 80,
        saturday_daytime: 30,
        saturday_evening: 80,
        sunday_daytime: 30        
      }
    }
  end

  def available_places(resource_category, clock = @clock)
    from_date, schedule_in_force = @availability_schedule.sort_by {|k,v| k || ""}.reverse.find do |from_date, schedule|
      from_date.nil? || DateTime.parse(from_date) <= clock.now
    end
    schedule_in_force[resource_category.to_sym] || 0
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

  def waiting_list_open?(resource_category, clock = @clock)
    future_schedules = @availability_schedule.select do |from_date, schedule|
      from_date && DateTime.parse(from_date) > clock.now
    end
    ! future_schedules.any? {|from_date, schedule| schedule.has_key?(resource_category.to_sym)}
  end

  def next_ticket_release_date(resource_category, clock = @clock)
    future_schedules = @availability_schedule.sort_by {|k,v| k||""}.select do |from_date, schedule|
      from_date && DateTime.parse(from_date) > clock.now && schedule.has_key?(resource_category.to_sym)
    end
    if future_schedules.any? 
      DateTime.parse(future_schedules[0][0])
    else
      nil
    end
  end

  def make_reservation(params, clock = @clock)
    ticket_type_name = params.delete(:ticket_type)
    ticket_type = TicketType.find_by_name(ticket_type_name) or raise "Couldn't find ticket type #{ticket_type_name}"
    captcha_valid = params.delete(:captcha_valid)
    reservation = Reservation.new(params.merge(state: "new", reference: random_reference, ticket_type: ticket_type))
    reservation.requested_at = clock.now
    if reservation.valid?
      if !captcha_valid
        reservation.errors.add(:base, "Word verification response is incorrect, please try again.")
      elsif remaining_places(ticket_type.resource_category) > 0
        reservation.save
        reservation.reserve
        reservation.set_payment_due!(clock)

        # If they reserved a non-sleeping place when sleeping was full up, add them to the sleeping waiting list
        if reservation.resource_category.to_sym == :non_sleeping && remaining_places(:sleeping) == 0 && waiting_list_open?(:sleeping)
          reservation.add_to_waiting_list(:sleeping)
        end
      elsif waiting_list_open?(ticket_type.resource_category)
        reservation.save
        reservation.add_to_waiting_list(reservation.resource_category)

        # On the waiting list for a non-sleeping place they are also added to the sleeping waiting list
        if reservation.resource_category.to_sym == :non_sleeping && remaining_places(:sleeping) == 0 && waiting_list_open?(:sleeping)
          reservation.add_to_waiting_list(:sleeping)
        end
      else
        reservation.errors.add(:base, "No places left for that ticket type. You can buy tickets on #{next_ticket_release_date(reservation.resource_category)}.")
      end
    end
    reservation
  end

  def place_day_ticket_order(params, clock = @clock)
    ticket_types = TicketType.find_all((params[:ticket_types] || {}).keys)
    order = DayTicketOrder.new(params.merge(state: "new", reference: random_reference, ticket_types: ticket_types))
    order.save
    order
  end

  def allocate_place_to(waiting_list_entry, clock = @clock)
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