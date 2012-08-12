ActiveAdmin.register Reservation do
  form do |f|
    f.inputs "Administration" do
      f.input :state, as: :select, collection: Reservation.state_machine.states.map(&:name)
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
