Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    post '/trips', to: 'trips#create'

    namespace :stats do
      get '/weekly', to: 'stats#weekly'
      get '/monthly', to: 'stats#monthly'
    end
  end
end
