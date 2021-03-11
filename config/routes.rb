Rails.application.routes.draw do
  devise_for :users
  
  namespace :api, defaults: {format: :json} do
    namespace :v1 do 
      devise_scope :user do
        post "sign_up", to: "registrations#create"
        post "sign_in", to: "sessions#create"
        delete "sign_out", to: "sessions#destroy"
      end

      namespace :admin do
        
      end

      get "account_info", to: "account#index"
      patch "update_account", to: "account#update"

      # Workspace
      resources :workspace, only: %i(index edit update create)
      get "user_list_workspace", to: "workspace#user_list_workspace"
    end
  end
end
