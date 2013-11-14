require 'csv'

class Reporter
  def report
    %w{reservations day_ticket_orders refunds_due}.each do |type|
      data = self.send(type.to_sym)
      filename = "#{type}.csv"
      writer = CSV.open(filename, 'w')
      data.each { |row| writer << row }
      writer.close
      puts "Wrote #{filename}"
    end
  end

  def reservations
    headings = ["name", "phone_number", "ticket_type", "state", "balance", "payment_method", "comments"]

    reservations = Reservation.where("state not in ('cancelled', 'waiting_list')").order(:state, :name).all.map do |r|
      [r.name, r.phone_number, r.ticket_type.name, r.state, (r.balance if r.payment_method=='gocardless'), r.payment_method, r.comments]
    end

    [headings] + reservations
  end

  def day_ticket_orders
    headings = ["name", "phone_number", "tickets", "state", "comments"]

    reservations = DayTicketOrder.where("state not in ('cancelled', 'waiting_list')").order(:state, :name).all.map do |r|
      [r.name, r.phone_number, r.ticket_types.map(&:name).join(", "), r.state, r.comments]
    end

    [headings] + reservations
  end

  def refunds_due
    headings = ["name", "phone_number", "tickets", "state", "comments"]

    reservations = DayTicketOrder.where(state: "cancelled").order(:state, :name).all.map do |r|
      [r.name, r.phone_number, r.email, r.ticket_types.map(&:name).join(", "), r.state, r.balance, r.comments]
    end

    [headings] + reservations
  end
end
