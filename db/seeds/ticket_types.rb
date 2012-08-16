def seed_ticket_types
  TicketType.create!(
    name: "Full, standard", 
    description: "Full weekend with food and indoor camping, standard rate", 
    price_in_pence: 3000,
    gocardless_url: "https://gocardless.com/pay/VXF4PVEE",
    paypal_partial: "paypal_full_standard",
    resource_category: "sleeping")
  TicketType.create!(
    name: "Full, concession",
    description: "Full weekend with food and indoor camping, really skint",
    price_in_pence: 2500,
    gocardless_url: "https://gocardless.com/pay/GZSJ4T37",
    paypal_partial: "paypal_full_concession",
    resource_category: "sleeping")
  TicketType.create!(
    name: "Non-sleeping, full",
    description: "Full weekend with food but NO ACCOMODATION, standard rate",
    price_in_pence: 2000,
    gocardless_url: "https://gocardless.com/pay/EJAX31PT",
    paypal_partial: "paypal_nonsleeping_full",
    resource_category: "non_sleeping")
  TicketType.create!(
    name: "Non-sleeping, concession",
    description: "Full weekend with food but NO ACCOMODATION, really skint",
    price_in_pence: 1800,
    gocardless_url: "https://gocardless.com/pay/YW453Y2X",
    paypal_partial: "paypal_nonsleeping_concession",
    resource_category: "non_sleeping")
end
