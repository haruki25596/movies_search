Rails.application.routes.draw do

  devise_for :users
  root 'movies#index'

  resources :movies, only: [:index, :show] do
    collection do
      get :search
    end
    resource :interests, only: [:create, :destroy]
  end


  post 'follow/:id' => 'relationships#follow', as: 'follow' # フォローする
  post 'unfollow/:id' => 'relationships#unfollow', as: 'unfollow' # フォロー外す
  get 'users/:id/follower'=> 'relationships#follower', as: 'follower_user'
  get 'users/:id/followed'=> 'relationships#followed', as: 'followed_user'

  resources :users, only: [:index, :show, :edit, :update] do
    resources :interests, only: [:index]
  end

  resources :reviews, only: [:new, :create, :index, :show, :destroy] do
    resource :post_comments, only: [:create, :destroy]
    resource :goods, only: [:create, :destroy]
    resource :bads, only: [:create, :destroy]
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
