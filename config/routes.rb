Rails.application.routes.draw do
  resources :rooms
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users, only: %i[create] do 
        collection do
          post :sign_in
        end
      end
    end
  end
end