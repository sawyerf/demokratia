Rails.application.routes.draw do
  get 'votes/:id' => 'votes#show'
  put 'for/:id' => 'votes#for'
  put 'against/:id' => 'votes#against'
  post 'for/:id' => 'votes#for'
  post 'against/:id' => 'votes#against'
  get '' => 'votes#index'
  post '' => 'votes#create'
  get 'register' => 'users#register'
  post 'register' => 'users#create'
  get 'login' => 'users#login'
  post 'login' => 'users#connect'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
