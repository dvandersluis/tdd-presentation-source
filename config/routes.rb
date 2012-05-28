Tdd::Application.routes.draw do
  match "login" => "users#login", :via => [:get, :post]
  get "logout" => "users#logout"
  
  resources :accounts, :only => :index do
    member do
      match :deposit, :via => [:get, :post]
      match :withdraw, :via => [:get, :post]
      match :transfer, :via => [:get, :post]
    end
  end
end
