Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :messages, only: [:new, :create]

  get '/conversations/:id', to: 'messages#show'

  post '/reply', to: 'messages#receive_message'

  root to: 'messages#new'
end
