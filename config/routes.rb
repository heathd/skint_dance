SkintDance::Application.routes.draw do
  match ':action', controller: :pages
  root :to => 'pages#index'
end
