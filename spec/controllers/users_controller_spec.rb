require 'controllers/spec_helper'

describe UsersController do
  describe "#login" do
    let(:user) { User.make! }
    
    it "should redirect if already logged in" do
      session[:user_id] = user.id
      get :login
      response.should redirect_to accounts_path
    end
    
    context "with a valid username and password" do
      before { post :login, :username => user.username, :password => user.password }
      
      it "should set session[:user_id]" do
        session[:user_id].should == user.id
      end
      
      it "should redirect to the accounts index" do
        response.should redirect_to accounts_path  
      end
    end
    
    it "should display an error if the username is invalid" do
      post :login, :username => "username", :password => "password"
      flash[:error].should == :invalid_username_or_password
    end
    
    it "should display an error if the password is invalid" do
      post :login, :username => user.username, :password => "wrong password"
      flash[:error].should == :invalid_username_or_password
    end
  end
  
  describe "#logout" do
    let(:user) { User.make! }
    
    before do
      session[:user_id] = user.id
      get :logout
    end
    
    it "should clear session[:user_id]" do
      session[:user_id].should be_nil
    end
    
    it "should redirect to the login page" do
      response.should redirect_to :action => :login
    end
  end
end