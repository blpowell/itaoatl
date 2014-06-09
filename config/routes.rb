Rails.application.routes.draw do

  root 'pages#index'

  get 'events', to: 'events#index'
  get 'events/next', to: 'events#next'

end
