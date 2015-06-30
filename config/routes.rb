TicketWin::Application.routes.draw do

  root "pages#home"
  get "inside", to: "pages#inside", as: "inside"
  get "/contact", to: "pages#contact", as: "contact"
  get "/terms", to: "pages#terms", as: "terms"
    get "/organizer_terms", to: "pages#organizer_terms", as: "organizer_terms"
  post "/emailconfirmation", to: "pages#email", as: "email_confirmation"
  get "/checkin", to: "checkins#index", as: "checkin"

  devise_for :users

  namespace :admin do
    root "base#index"
    resources :users
  end


  resources :organizations, only: :show
  resources :events do
    resources :tickets, only: [:index, :update]
  end

  resources :orders, except: [:new, :show] do
    member { get 'checkout' }
  end
  get '/redeem/:redemption_code', to: 'orders#redeem', as: 'redeem_order'

  namespace :stripe do
    get 'connect'
    get 'confirm'
  end
end
