Rails.application.routes.draw do
  namespace :api do
    get 'dropbox', to: 'dropbox#challenge'
  end

  root to: 'visitors#index'
end
