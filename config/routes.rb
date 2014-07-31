Rails.application.routes.draw do

  get '/events/:source_id/:id', to: 'events#show', as: :event

  resources :events, only: :index

  root to: 'home#index'
end
