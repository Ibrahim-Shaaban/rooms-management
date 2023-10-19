Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users, only: %i[create] do 
        collection do
          post :sign_in
        end
      end

      resources :rooms

    end
  end
end