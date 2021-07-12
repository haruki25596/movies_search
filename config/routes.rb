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
  post 'goods/:movie_id' => 'goods#create', as: 'good'
  post 'bads/:movie_id' => 'bads#create', as: 'bad'
  delete 'goods/:movie_id' => 'goods#destroy'
  delete 'bads/:movie_id' => 'bads#destroy'

  get 'users/:id/follower'=> 'relationships#follower', as: 'follower_user'
  get 'users/:id/followed'=> 'relationships#followed', as: 'followed_user'

  resources :notifications, only: [:index] do
    collection do
      delete 'destroy_all'
    end
  end

  resources :users, only: [:index, :show, :edit, :update] do
    resources :interests, only: [:index]
  end

  resources :reviews, only: [:new, :create, :update, :edit, :destroy] do
    resources :review_comments, only: [:new, :create, :destroy]
  end



  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
