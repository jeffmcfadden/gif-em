Rails.application.routes.draw do

  resources :images do
    collection do
      get :tag_cloud
      post :create_from_url
    end
    
    member do
      post :remove_tag
      patch :add_tag
      post :imagga
    end
  end

  root 'images#index'

end
