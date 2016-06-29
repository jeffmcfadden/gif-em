Rails.application.routes.draw do

  resources :images do
    member do
      post :remove_tag
    end
  end

  root 'images#index'

end
