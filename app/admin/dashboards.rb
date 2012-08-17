ActiveAdmin::Dashboards.build do

  section "Sleeping places" do
    div do
      render 'recent_reservations', resource_category: :sleeping
    end

    div do
      render 'waiting_list', resource_category: :sleeping
    end
  end
  
  section "Non-sleeping places" do
    div do
      render 'recent_reservations', resource_category: :non_sleeping
    end

    div do
      render 'waiting_list', resource_category: :non_sleeping
    end
  end

end
