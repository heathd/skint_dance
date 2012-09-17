class AddDayTickets < ActiveRecord::Migration
  def up
    TicketType.create!(
      name: "Friday evening", 
      description: "Friday evening dance (after 8.30pm)", 
      price_in_pence: 500,
      resource_category: "friday_evening")
    TicketType.create!(
      name: "Saturday daytime",
      description: "Saturday daytime workshops 10pm-6pm",
      price_in_pence: 500,
      resource_category: "saturday_daytime")
    TicketType.create!(
      name: "Saturday evening",
      description: "Saturday evening dance (after 8.30pm)",
      price_in_pence: 500,
      resource_category: "saturday_evening")
    TicketType.create!(
      name: "Sunday daytime",
      description: "Sunday daytime, workshops and dance 10pm - 4pm",
      price_in_pence: 500,
      resource_category: "sunday_daytime")
  end

  def down
  end
end
