ActiveAdmin.register Reservation do
  index do
    column "Name", sortable: :name do |r| link_to r.name, admin_reservation_path(r) end
    column "Email", sortable: :email do |r| link_to r.email, admin_reservation_path(r) end
    column "Ref" do |r| r.reference end
    column :state
    column :ticket_type
    column :requested_at
    column :payment_due
  end

  form do |f|
    f.inputs "Administration" do
      f.input :state, as: :select, collection: Reservation.state_machine.states.map(&:name)
      f.input :payment_method, as: :select, collection: Reservation::PAYMENT_METHODS
      f.input :ticket_type, as: :select, collection: TicketType.all
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
      f.input :requested_at, disabled: true
      f.input :payment_due
    end

    f.buttons
  end
end

ActiveAdmin.register WaitingListEntry do
  filter :resource_category, label: "Type", as: :select, collection: %w{sleeping non_sleeping}
  index do
    column "Name" do |w| link_to w.reservation.name, admin_waiting_list_entry_path(w) end
    column "Email", sortable: :email do |w| link_to w.reservation.email, admin_waiting_list_entry_path(w) end
    column "Date", :added_at
    column "Type", :resource_category
  end

  member_action :allocate, :method => :post do
    waiting_list_entry = WaitingListEntry.find(params[:id])
    RESERVATION_MANAGER.allocate_place_to(waiting_list_entry)
    redirect_to admin_reservation_path(waiting_list_entry.reservation), notice: "Place allocated"
  end

end
