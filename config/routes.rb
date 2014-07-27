Rails.application.routes.draw do

  resources :events, only: :index do
    get ':source/:id', to: :show, as: :event, on: :collection
  end

  root to: 'home#index'
end
