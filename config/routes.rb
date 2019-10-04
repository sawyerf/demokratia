Rails.application.routes.draw do
  get 'init', to: 'admin#init'

  get 'votes/:id', to: 'votes#show'
  post 'votes/:id', to: 'votes#vote'

  get '', to: 'votes#index'
  post '', to: 'votes#create'

  get 'register', to: 'users#register'
  post 'register', to: 'users#create'

  get 'login', to: 'users#login'
  post 'login', to: 'users#connect'

  get 'disconnect', to: 'users#disconnect'

  post 'inbox', to: 'inbox#Recv', default: { format: 'json' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
