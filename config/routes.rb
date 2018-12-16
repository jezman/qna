Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users

  resources :questions do
    resources :attachments, shallow: true, only: :destroy

    resources :answers, shallow: true, except: %i[index show] do
       member do
         patch :best
         # delete :delete_attachment
       end
    end
  end
end
