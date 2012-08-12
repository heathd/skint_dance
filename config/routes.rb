SkintDance::Application.routes.draw do

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  resources :reservations do
    get :success
  end

  # get "reservations/success/:reference" => "reservations#success", as: "reservation_success"

  match ':action', controller: :pages
  root :to => 'pages#index'
end
