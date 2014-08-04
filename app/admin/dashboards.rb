ActiveAdmin.register_page "Dashboard" do
  content do
    columns do
      column do
        panel "Sleeping places" do
          div do
            render 'recent_reservations', resource_category: :sleeping
          end

          div do
            render 'waiting_list', resource_category: :sleeping
          end
        end
      end
      
      column do
        panel "Non-sleeping places" do
          div do
            render 'recent_reservations', resource_category: :non_sleeping
          end

          div do
            render 'waiting_list', resource_category: :non_sleeping
          end
        end
      end
    end
  end
end
