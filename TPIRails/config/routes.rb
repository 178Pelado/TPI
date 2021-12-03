Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  devise_for :users

  root to: 'professionals#index'

  resources :professionals do
    resources :appointments
    member do
      delete 'cancel_all_appointments', action: 'cancel_all_appointments'
    end
  end
  scope "/administracion" do
    resources :users
  end
  
end