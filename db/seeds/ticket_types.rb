def seed_ticket_types
  TicketType.create!(
    name: "Fri-Sun, standard", 
    description: "Fri-Sun with food and indoor camping, standard rate", 
    price_in_pence: 3000,
    gocardless_url: "https://gocardless.com/pay/VWQRH5YA",
    paypal_partial: "paypal_full_standard",
    resource_category: "sleeping")
  TicketType.create!(
    name: "Fri-Sun, concession",
    description: "Fri-Sun with food and indoor camping, really skint",
    price_in_pence: 2500,
    gocardless_url: "https://gocardless.com/pay/CN03CGHR",
    paypal_partial: "paypal_full_concession",
    resource_category: "sleeping")
  TicketType.create!(
    name: "Fri-Mon, standard", 
    description: "Fri-Mon with food and indoor camping, standard rate", 
    price_in_pence: 4500,
    gocardless_url: "https://gocardless.com/pay/PDKE8809",
    paypal_partial: "paypal_fri_mon_standard",
    resource_category: "sleeping")
  TicketType.create!(
    name: "Fri-Mon, concession",
    description: "Fri-Mon with food and indoor camping, really skint",
    price_in_pence: 4000,
    gocardless_url: "https://gocardless.com/pay/0ZK04693",
    paypal_partial: "paypal_fri_mon_skint",
    resource_category: "sleeping")
  TicketType.create!(
    name: "Non-sleeping, Fri-Sun, full",
    description: "Fri-Sun with food but NO ACCOMODATION, standard rate",
    price_in_pence: 2000,
    gocardless_url: "https://gocardless.com/pay/2BJ5PF7W",
    paypal_partial: "paypal_nonsleeping_full",
    resource_category: "non_sleeping")
  TicketType.create!(
    name: "Non-sleeping, Fri-Sun, concession",
    description: "Fri-Sun with food but NO ACCOMODATION, really skint",
    price_in_pence: 1800,
    gocardless_url: "https://gocardless.com/pay/ATQHC81V",
    paypal_partial: "paypal_nonsleeping_concession",
    resource_category: "non_sleeping")
  TicketType.create!(
    name: "Non-sleeping, Fri-Mon, full",
    description: "Fri-Mon with food but NO ACCOMODATION, standard rate",
    price_in_pence: 3500,
    gocardless_url: "https://gocardless.com/pay/HXB87FAF",
    paypal_partial: "paypal_fri_mon_nonsleeping_standard",
    resource_category: "non_sleeping")
  TicketType.create!(
    name: "Non-sleeping, Fri-Mon, full",
    description: "Fri-Mon with food but NO ACCOMODATION, really skint",
    price_in_pence: 3300,
    gocardless_url: "https://gocardless.com/pay/AK033KTY",
    paypal_partial: "paypal_fri_mon_nonsleeping_skint",
    resource_category: "non_sleeping")
end
