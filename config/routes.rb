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
      resources :workspace
      get "user_list_workspace", to: "workspace#user_list_workspace"
      post "workspace/:workspace_id/add_members", to: "workspace#add_members"
      post "workspace/:workspace_id/remove_members", to: "workspace#remove_members"
      get "workspace/:workspace_id/all_users", to: "workspace#all_users"
      get "workspace/:workspace_id/all_members", to: "workspace#all_members"
    end
  end
end
