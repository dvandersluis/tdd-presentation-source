require 'spec_helper'

describe UsersController do
  it "should route GET /login to users#login" do
    { :get => "login" }.should route_to(:controller => "users", :action => "login")
  end
  
  it "should route POST /login to users#login" do
    { :post => "login" }.should route_to(:controller => "users", :action => "login")
  end
  
  it "should route GET /logout to users#logout" do
    { :get => "logout" }.should route_to(:controller => "users", :action => "logout")
  end
end
