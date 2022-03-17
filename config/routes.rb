Rails.application.routes.draw do
  resources :questions, only: %i[index show new create]
  end

