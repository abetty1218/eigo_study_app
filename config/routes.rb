Rails.application.routes.draw do
# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
resources :users
resources :notices
resources :problems do
  resources :questions do
    collection do
      patch :update_all
      get :edit_all
    end
  end

  member do
    patch :released
  end

end

root 'tops#home'
get    '/login',   to: 'sessions#new'
post   '/login',   to: 'sessions#create'
delete '/logout',  to: 'sessions#destroy'

end
