Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'toppages#index'
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  get 'signup', to: 'users#new'
  resources :users, only: [:index, :show, :create, :edit, :update] do
    member do
      get :followings
      get :followers
      get :match
    end
  end
  
  resources :searches, only: [:new]
  resources :battles, only: [:create, :destroy, :update, :show] do
    resources :rooms, only: [:new, :show, :destroy, :create]
     member do
      patch :refuse
      patch :done
    end
  end
  
  resources :comments, only: [:create, :destroy]
  
end
