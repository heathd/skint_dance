ActiveAdmin.register Reservation do
  index do
    column "Name", sortable: :name do |r| link_to r.name, edit_admin_reservation_path(r) end
    column :email
    column "Ref" do |r| r.reference end
    column :state
    column :ticket_type
    column :requested_at
    column :payment_due
    column :balance
  end

  show do |reservation|
    attributes_table do
      row :name
      row :email
      row :phone_number
      row :reference
      row :state
      row :payment_method
      row :ticket_type
      row :camping
      row :what_can_you_help_with
      row :participate_in_fare_pool
      row :dietary_requirements
      row :comments
      row :requested_at
      row :updated_at
      row :payment_due
      row :balance
    end
    active_admin_comments
  end

  form do |f|
    f.inputs "Applicant" do
      f.input :name
      f.input :email
      f.input :phone_number
    end

    f.inputs "Administration" do
      f.input :state, as: :select, collection: Reservation.state_machine.states.map(&:name)
      f.input :payment_method, as: :select, collection: Reservation::PAYMENT_METHODS
      f.input :ticket_type, as: :select, collection: TicketType.all
      f.input :camping
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

ActiveAdmin.register DayTicketOrder do
  show do |order|
    attributes_table do
      row :name
      row :email
      row :phone_number
      row :reference
      row :state
      row :ticket_types do
        order.ticket_types.map(&:name).join(", ")
      end
      row :camping
      row :what_can_you_help_with
      row :comments
      row :created_at
      row :updated_at
      row :balance do
        order.balance
      end
    end
    active_admin_comments
  end

  form do |f|
    f.inputs "Applicant" do
      f.input :name
      f.input :email
      f.input :phone_number
    end

    f.inputs "Administration" do
      f.input :state, as: :select, collection: Reservation.state_machine.states.map(&:name)
      f.input :ticket_types, as: :select, collection: TicketType.day
      f.input :camping
    end

    f.inputs "Other" do
      f.input :what_can_you_help_with
      f.input :comments
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

ActiveAdmin.register GocardlessBill do
  index do
    column :user_first_name do |b| link_to b.user_first_name, edit_admin_gocardless_bill_path(b) end
    column :user_last_name
    column :user_email
    column :reservation, sortable: "reservation_id"
    column :amount
    column "Ticket", :name
    column :status
  end

  form do |f|
    f.inputs "Reservation" do
      f.input :reservation, as: :select, collection: (Reservation.order(:name).map do |r| 
        ["#{r.name} - #{r.ticket_type.name} (#{r.ticket_type.formatted_price}) - #{r.state}", r.id]
      end)
    end

    f.inputs "Transaction details" do
      f.input :user_first_name, disabled: true
      f.input :user_last_name, disabled: true
      f.input :user_email, disabled: true
      f.input :amount, disabled: true
      f.input :name, disabled: true
    end

    f.buttons
  end
end

