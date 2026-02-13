Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :projects
  post "/projects/:id/members", to: "project_memberships#create"
  delete "/projects/:id/members/:user_id", to: "project_memberships#destroy"
end
