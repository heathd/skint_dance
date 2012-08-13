ActiveAdmin.register Reservation do
  index do
    column "Name", sortable: :name do |r| link_to r.name, admin_reservation_path(r) end
    column "Email", sortable: :email do |r| link_to r.email, admin_reservation_path(r) end
    column "Ref" do |r| r.reference end
    column :state
    column :ticket_type
    column :created_at
  end

  form do |f|
    f.inputs "Administration" do
      f.input :state, as: :select, collection: Reservation.state_machine.states.map(&:name)
      f.input :payment_method, as: :select, collection: Reservation::PAYMENT_METHODS
      f.input :ticket_type, as: :select, collection: Reservation::TicketType.options
      f.input :camping
    end

    f.inputs "Applicant" do
      f.input :name
      f.input :email
      f.input :phone_number
    end

    f.inputs "Other" do
      f.input :what_can_you_help_with
      f.input :participate_in_fare_pool
      f.input :dietary_requirements
      f.input :comments
      f.input :created_at
      f.input :updated_at
    end

    f.buttons
  end

  
end
