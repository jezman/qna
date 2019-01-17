Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users

  concern :likable do
    member do
      post :vote_up, :vote_down
      delete :revoke
    end
  end

  resources :questions, concerns: :likable do
    resources :answers, concerns: :likable, shallow: true, except: %i[index show] do
      member do
        patch :best
      end
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :badges, only: :index

  mount ActionCable.server => '/cable'
end
