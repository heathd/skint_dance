def seed_ticket_types
  TicketType.create!(
    price_in_pence: 1800,
    name: "Non-sleeping, Fri-Sun, concession",
    description: "Fri-Sun with food but NO ACCOMODATION, really skint",
    gocardless_url: "https://dashboard.gocardless.com/api/template_plans/0P64M306S7/paylink",
    resource_category: "non_sleeping",
    paypal_partial: "paypal_nonsleeping_concession"
  )
  TicketType.create!(
    price_in_pence: 2000,
    name: "Non-sleeping, Fri-Sun, full",
    description: "Fri-Sun with food but NO ACCOMODATION, standard rate",
    gocardless_url: "https://dashboard.gocardless.com/api/template_plans/0P64W96GER/paylink",
    resource_category: "non_sleeping",
    paypal_partial: "paypal_nonsleeping_full"
  )
  TicketType.create!(
    price_in_pence: 2500,
    name: "Fri-Sun, concession",
    description: "Fri-Sun with food and indoor camping, really skint",
    gocardless_url: "https://dashboard.gocardless.com/api/template_plans/0P64CM03BH/paylink",
    resource_category: "sleeping",
    paypal_partial: "paypal_full_concession"
  )
  TicketType.create!(
    price_in_pence: 3000,
    name: "Fri-Sun, standard", 
    description: "Fri-Sun with food and indoor camping",
    gocardless_url: "https://dashboard.gocardless.com/api/template_plans/0P645HJANR/paylink",
    resource_category: "sleeping",
    paypal_partial: "paypal_full_standard"
  )
  TicketType.create!(
    price_in_pence: 3300,
    name: "Non-sleeping, Fri-Mon, full",
    description: "Fri-Mon with food but NO ACCOMODATION, really skint",
    gocardless_url: "https://dashboard.gocardless.com/api/template_plans/0P645DR5HN/paylink",
    resource_category: "non_sleeping",
    paypal_partial: "paypal_fri_mon_nonsleeping_skint"
  )
  TicketType.create!(
    price_in_pence: 3500,
    name: "Non-sleeping, Fri-Mon, full",
    description: "Fri-Mon with food but NO ACCOMODATION, standard rate",
    gocardless_url: "https://dashboard.gocardless.com/api/template_plans/0P64ZG7FWR/paylink",
    resource_category: "non_sleeping",
    paypal_partial: "paypal_fri_mon_nonsleeping_standard"
  )
  TicketType.create!(
    price_in_pence: 4000,
    name: "Fri-Mon, concession",
    description: "Fri-Mon with food and indoor camping, really skint",
    gocardless_url: "https://dashboard.gocardless.com/api/template_plans/0P64YM0MW9/paylink",
    resource_category: "sleeping",
    paypal_partial: "paypal_fri_mon_skint"
  )
  TicketType.create!(
    price_in_pence: 4500,
    name: "Fri-Mon, standard", 
    description: "Fri-Mon with food and indoor camping",
    gocardless_url: "https://dashboard.gocardless.com/api/template_plans/0P648XY9B6/paylink",
    resource_category: "sleeping",
    paypal_partial: "paypal_fri_mon_standard"
  )
end
