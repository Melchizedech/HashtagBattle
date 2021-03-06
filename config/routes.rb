Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  # You can have the root of your site routed with "root"

  use_doorkeeper

  root 'home#index'

  get '/logout', to: 'home#logout'

  resources :battle
  resources :hashtag
  get '/battle/:battle_id/chartdata', to: 'battle#pie_chart_data', as: 'pie_chart_data'
  get '/battle/:battle_id/stackedlinechartdata', to: 'battle#stacked_line_chart_data', as: 'stacked_line_chart_data'


  get '/me', to: 'user#show', as: 'show_user'
  get '/me/battle', to: 'battle#user_battles', as: 'battle_index_user'
  get '/me/hashtag', to: 'hashtag#user_hashtags', as: 'hashtag_index_user'

  get '/me/access_token', to: 'user#generate_access_token', as: 'generate_access_token'

  get '/hashtag/:hashtag_id/evolutionchartdata', to: 'hashtag#evolution_chart_data', as: 'evolution_chart_data'
  get '/hashtag/:id/update_count', to: 'hashtag#update_count', as: 'update_count'


  get '/auth/twitter/callback', to: 'home#callback'
  get '/auth/failure', to: 'home#failure'

  mount BattleHashtagAPI, at: '/api'
  
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
