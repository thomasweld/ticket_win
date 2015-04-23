TicketWin::Application.routes.draw do
  root "pages#home"
  get "inside", to: "pages#inside", as: "inside"
  get "/contact", to: "pages#contact", as: "contact"
  post "/emailconfirmation", to: "pages#email", as: "email_confirmation"


  devise_for :users

  namespace :admin do
    root "base#index"
    resources :users

  end

  resources :events

end
