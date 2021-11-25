Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'professionals#index'

  resources :professionals do
    resources :appointments do
      collection do
        get '/cancel-all', action: 'cancel_all'
      end
    end
  end
end
