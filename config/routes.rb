Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions, only: %i[index show new create destroy] do
    resources :answers, only: %i[new create destroy], shallow: true
  end
end
