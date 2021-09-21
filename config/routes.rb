Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    post '/trips', to: 'trips#create', as: :create_trip

    namespace :stats do
      get '/weekly', to: 'stats#weekly', as: :weekly_stats
      get '/monthly', to: 'stats#monthly', as: :monthly_stats
    end
  end
end
