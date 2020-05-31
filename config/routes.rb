Rails.application.routes.draw do

  devise_for :users, :controllers => {
   :registrations => 'users/registrations',
   :sessions => 'users/sessions',
   :omniauth_callbacks => 'users/omniauth_callbacks'
 }
  devise_scope :user do
    get "users", :to => "users/registrations#index"
    get 'users/:id/edit' => 'users/registrations#edit', as: :edit_user
    match 'users/:id', to: 'users/registrations#update', via: [:patch, :put], as: :user
    delete 'users/:id', to: 'users/registrations#destroy', as: :user_delete
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # resources :users
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
  resources :notices
end
