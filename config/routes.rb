SkintDance::Application.routes.draw do

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  match "/day_tickets/closed" => "day_ticket_orders#closed", as: :day_tickets_closed
  
  resources :day_ticket_orders, path: "day_tickets" do
  end

  resources :reservations do
    get :success
  end

  resources :pre_reservations do
    get :success
  end

  # get "reservations/success/:reference" => "reservations#success", as: "reservation_success"

  match ':action', controller: :pages
  root :to => 'pages#index'
end
