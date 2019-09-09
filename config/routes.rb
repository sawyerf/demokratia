Rails.application.routes.draw do
  get 'votes/:id' => 'votes#show'
  post 'votes/:id' => 'votes#vote'

  get '' => 'votes#index'
  post '' => 'votes#create'

  get 'register' => 'users#register'
  post 'register' => 'users#create'

  get 'login' => 'users#login'
  post 'login' => 'users#connect'

  get 'disconnect' => 'users#disconnect'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
