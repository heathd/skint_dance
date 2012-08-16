class CreateWaitingList < ActiveRecord::Migration
  class WaitingListEntry < ActiveRecord::Base
    belongs_to :reservation
  end
  class TicketType < ActiveRecord::Base; end
  class Reservation < ActiveRecord::Base
    belongs_to :ticket_type
  end

  def up
    create_table :waiting_list_entries do |t|
      t.integer :reservation_id
      t.string :resource_category
      t.datetime :added_at
    end

    [:sleeping, :non_sleeping].each do |resource_category|
      waiting_for(resource_category).map do |reservation|
        WaitingListEntry.create(reservation: reservation, added_at: reservation.requested_at, resource_category: resource_category)
      end
    end
  end

  def waiting_for(resource_category)
    if resource_category == :sleeping
      date_when_all_sleeping_places_were_full = DateTime.parse("August 13, 2012 18:58")
      Reservation.joins(:ticket_type).where(
        "(ticket_types.resource_category='sleeping' AND reservations.state='waiting_list') OR " +
        "(ticket_types.resource_category='non_sleeping' AND " +
          "reservations.state in ('new', 'reserved', 'waiting_list') AND " +
          "reservations.requested_at > ?)", date_when_all_sleeping_places_were_full)
    else
      Reservation.joins(:ticket_type).where("ticket_types.resource_category" => resource_category, state: :waiting_list)
    end
  end

  def down
    drop_table :waiting_list_entries
  end
end
