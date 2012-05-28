require 'controllers/spec_helper'

describe AccountsController do
  let(:user) { User.make! }
  before { session[:user_id] = user.id }
  
  describe "#index" do
    let(:accounts) do
      [].tap do |accounts|
        3.times { accounts << Account.make!(:user => user) }
      end
    end
    
    before { accounts }
    
    it "should redirect to the login page if accessed without logging in first" do
      session[:user_id] = nil
      get :index
      response.should redirect_to login_path
    end
  
    it "should collect accounts belonging to the current user" do
      get :index
      assigns(:accounts).should == accounts
    end
    
    it "should not collect any accounts that do not belong to the current user" do
      3.times { Account.make!(:user => User.make) }
      get :index
      assigns(:accounts).should == accounts
    end
  end
  
  describe "#deposit" do
    let(:account) { Account.make!(:user => user) }
    
    it "via GET should redirect to the login page if accessed without logging in first" do
      session[:user_id] = nil
      get :deposit, :id => account
      response.should redirect_to login_path
    end
    
    it "via POST should redirect to the login page if accessed without logging in first" do
      session[:user_id] = nil
      post :deposit, :id => account
      response.should redirect_to login_path
    end
    
    it "should redirect to index after a successful deposit" do
      post :deposit, :id => account, :amount => 50
      response.should redirect_to :action => :index
      flash[:notice].should == :successful_deposit
    end
  end
  
  describe "#withdraw" do
    let(:account) { Account.make!(:user => user) }
    
    it "via GET should redirect to the login page if accessed without logging in first" do
      session[:user_id] = nil
      get :withdraw, :id => account
      response.should redirect_to login_path
    end
    
    it "via POST should redirect to the login page if accessed without logging in first" do
      session[:user_id] = nil
      post :withdraw, :id => account
      response.should redirect_to login_path
    end
    
    it "should show an error if trying to withdraw more than the account balance" do
      post :withdraw, :id => account, :amount => 125
      flash[:error].should == "cannot withdraw more than #{account.balance}" 
    end
    
    it "should show an error if trying to withdraw not a multiple of 20 or 50" do
      post :withdraw, :id => account, :amount => 75
      flash[:error].should == "can only withdraw in multiples of 20 or 50" 
    end
    
    it "should redirect to index after a successful withdrawal" do
      post :withdraw, :id => account, :amount => 50
      response.should redirect_to :action => :index
      flash[:notice].should == :successful_withdrawal
    end
  end
  
  describe "#transfer" do
    let(:account) { Account.make!(:user => user) }
    let(:account2) { Account.make!(:user => user) }
    let(:account3) { Account.make!(:user => user) }
    
    it "via GET should redirect to the login page if accessed without logging in first" do
      session[:user_id] = nil
      get :transfer, :id => account
      response.should redirect_to login_path
    end
    
    it "via POST should redirect to the login page if accessed without logging in first" do
      session[:user_id] = nil
      post :transfer, :id => account
      response.should redirect_to login_path
    end
    
    it "should redirect to index after a successful transfer" do
      post :transfer, :id => account, :recipient => account2, :amount => 50
      response.should redirect_to :action => :index
      flash[:notice].should == :successful_transfer
    end
    
    it "should show an error if trying to transfer more than the account balance" do
      post :transfer, :id => account, :recipient => account2, :amount => 125
      flash[:error].should == "cannot transfer more than #{account.balance}" 
    end
    
    it "should collect other accounts belonging to the current user" do
      get :transfer, :id => account
      assigns(:recipients).should == [account2, account3]
    end
  end
end