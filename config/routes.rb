Rails.application.routes.draw do
  default_url_options :host => Rails.application.secrets[:default_url_options]
  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :users
  root to: "deploy#index"
  get "/deploy" => "deploy#index"
  get "/deploy/:deployment_id" => "deploy#show"

  resources :environments, only: [:show] do
    resources :config_files
    resources :logs
    get "/dispose" => "environments#dispose", as: :dispose
  end

  namespace :api do
    resources :deployments, only: [:show, :create] do
      post "redeployment", action: :redeployment
    end

    resources :logs, only: [:show]
    resources :deploy_environments, only: :show do
      post :scale
    end
  end

  ActiveAdmin.routes(self)
end
