Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users
  resources :problems do
    resources :questions do
      member do
        get :answer
      end
      collection do
        get :answer_index
        patch :create
        patch :update_all
        get :edit_all
      end
    end
    member do
      patch :released
      get :complete
    end

  end
  resources :questions_answers
  root 'tops#home'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :notices
end
