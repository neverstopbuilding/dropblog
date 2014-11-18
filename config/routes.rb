Rails.application.routes.draw do
  namespace :api do
    get 'dropbox', to: 'dropbox#challenge'
    post 'dropbox', to: 'dropbox#webhook', format: :json
  end

  root to: 'visitors#index'
end
