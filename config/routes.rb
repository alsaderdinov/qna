Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  concern :votable do
    member do
      post :upvote
      post :downvote
      delete :vote_canceling
    end
  end

  concern :commentable do
    member do
      post :create_comment
    end
  end

  resources :questions, concerns: %i[votable commentable] do
    resources :answers, concerns: %i[votable commentable], shallow: true, only: %i[create update destroy] do
      patch :best, on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy

  get '/profile/:id', to: 'users#show'
  resources :users, only: :show

  mount ActionCable.server => '/cable'
end
