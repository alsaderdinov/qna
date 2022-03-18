Rails.application.routes.draw do
  resources :questions, only: %i[index show new create]
    resources :answers, only: %i[new create show], shallow: true
  end

