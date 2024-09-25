Rails.application.routes.draw do
  devise_for :users

  resources :loans do
    member do
      patch :confirm
      patch :repay
      patch :accept_adjustment
      patch :reject_adjustment
    end
  end

  namespace :admin do
    resources :loans do
      member do
        patch :approve
        patch :reject
        get :adjust
        patch :update_adjustment
      end
    end
  end

  root to: 'loans#index'
end