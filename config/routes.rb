Rails.application.routes.draw do
  get 'votes/:id' => 'votes#show'
  put 'for/:id' => 'votes#for'
  put 'against/:id' => 'votes#against'
  get 'votes' => 'votes#index'
  post 'votes' => 'votes#create'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
