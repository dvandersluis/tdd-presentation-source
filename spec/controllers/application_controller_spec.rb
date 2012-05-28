require 'controllers/spec_helper'

describe ApplicationController do
  describe "#current_user" do
    it "should return an user object if session[:user_id] is set" do
      user = User.make!
      session[:user_id] = user.id
      controller.current_user.should == user
    end
    
    it "should return nil if session[:user_id] is unset" do
      controller.current_user.should be_nil
    end
  end
end