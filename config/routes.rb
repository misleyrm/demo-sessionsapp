Rails.application.routes.draw do

    # get 'dashboard' => 'home#dashboard'
    # root to: 'home#dashboard', as: '/'
    root 'home#dashboard'
    # get 'home/unregistered'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

    #Paperclip images

    get 'password_resets/new'

    get 'password_resets/edit'
    get 'password_resets' => 'password_resets#new'
    get 'login/create'

    get 'login/destroy'
    # The priority is based upon order of creation: first created -> highest priority.
    # See how all your routes lay out with "rake routes".
    get '/new' => 'users#new', :as => 'sign_up'
    # root :to => 'login#new'
    # root :to => 'lists#index'
    # You can have the root of your site routed with "root"

    get '/login' => 'login#new'
    post '/login' => 'login#create'
    get '/logout' => 'login#destroy'
    get '/lists/:id/showList' => 'lists#showList', as: 'list_showList'

    # get 'sessions' => 'sessions#index'
    # get 'sessions/new' => 'sessions#new'
    # get 'sessions/:id' => 'sessions#show'
    # post 'sessions/deleteSession/:id' => 'sessions#deleteSession'
    # get 'sessions/:session_id/blockers' => 'blockers#index'
    # get 'sessions/:session_id/completeds' => 'completeds#index'
    # get 'sessions/:session_id/wips' => 'wips#index'

    # patch :sign_up '/sign_up/:invitation_token', :controller => 'users', :action => 'new'

    post 'users/roleUpdate' => 'users#roleUpdate'

    post 'users/resend_activation' => 'users#resend_activation'
    # get 'lists/:id' => 'lists#complete_users'
    # post 'sessions/:session_id/wips/:id/update' => 'wips#update'
    # post 'sessions/:session_id/completeds/:id/update' => 'completeds#update'
    # post 'sessions/:session_id/blockers/:id/update' => 'blockers#update'

    # get the date from sessions index jquery-ui datepicker
    # post 'sessions/cleanDate' => 'sessions#cleanDate'
    # post 'teams/users' => 'teams#show_users'
    # post 'sessions/searchByUser' => 'sessions#searchByUser'
    # post 'sessions/:session_id/removeUser' => 'sessions#removeUser'
    # post 'sessions/:session_id/addUser' => 'sessions#addUser'
    # get 'user/:id' => 'users#edit'

    # resources :completeds
    # resources :blockers
    # resources :wips
    # resources :sessions do
    #   resources :wips
    #   resources :completeds
    #   resources :blockers
    # end
    resources :sessions
  #
    resources :users do
      resources :lists, :name_prefix => "user_"
      member do
        patch :updateAvatar
      end
    end

    resources :lists do
      resources :tasks, :name_prefix => "list_"
      resources :invitations
      resources :collaboration_users, :controller => 'users', :defaults => {:type => 'collaborator'}
      get :search, :on => :collection
      member do
        patch :num_incompleted_tasks
        get :complete_users
      end
    end


    # resources :users
    # resources :lists do
    #   resources :tasks , only: [:new, :create, :edit]
    #   resources :invitations
    #   resources :collaboration_users, :controller => 'users', :defaults => {:type => 'collaborator'}
    #   member do
    #     patch :num_incompleted_tasks
    #   end
    # end

    resources :tasks do
      resources :t_blockers, :controller => 'tasks', :defaults => {:type => 'blocker'}, :name_prefix => "tasks_"
      # get :autocomplete_user_first_name, :on => :collection
      member do
        patch :add_deadline
        patch :complete
        patch :changelist
        patch :importanttask
      end
    end


    # resources :applications do
    #   resource :owner, :controller => 'people', :defaults => {:type => 'owner'}
    #   resource :manager, :controller => 'people', :defaults => {:type => 'manager'}
    # end

    resources :account_activations, only: [:edit]

    resources :password_resets, only: [:new, :create, :edit, :update]
    mount ActionCable.server, at: '/cable'

    # resources :teams
    # get 'new_session' => 'sessions#new', as: 'new_session'
    # <%= link_to "New Session", new_session_path %>

    # get '/users/:name' => 'user#show', as: 'user_sessions'
    #this would redirect to the users_controller, show action,
    #where we must have:
    # @user = User.where(name: params[:name]).first_name
    # @sessions = @user.sessions

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
