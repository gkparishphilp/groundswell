Groundswell::Application.routes.draw do
    root to: 'homepage#index'
    resources :users, only: :update

    match '/home' => 'users#home', as: 'user_home'
    match '/settings' => 'users#settings', as: 'user_settings'
    match '/contact' => 'contacts#new', as: 'contact'
    match '/sitemap' => 'homepage#sitemap', as: 'sitemap'

    match '/dash' => 'providers#home', as: 'provider_home'

    devise_scope :user do
      match '/login' => 'sessions#new', as: 'login'
      match '/logout' => 'sessions#destroy', method: :delete, as: 'logout'
      match '/register' => 'registrations#new', as: 'register'
    end

    resources :admin, :only => :index do
    collection do
      get :app_events
      get :users
    end

  end
  resources :app_events, :only => :index
  resources :optins, :only => [ :create ]
    
  mount SwellMedia::Engine, :at => '/'
  # mount SwellTrials::Engine, :at => '/trials'

  devise_for :users, :controllers => { :omniauth_callbacks => 'oauth_credentials', :registrations => 'registrations', :sessions => 'sessions' }

end
