Rails.application.routes.draw do

  root 'pages#index'

  get 'events', to: 'events#index'
  get 'events/next', to: 'events#next'
  get 'why', to: 'pages#why'
  get 'swans', to: 'events#swans_fixtures'
end
