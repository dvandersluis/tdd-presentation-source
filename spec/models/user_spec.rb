require 'spec_helper'

describe User do
  describe "#save" do
    let(:user) { User.make }
    
    before { User.stub(:generate_password_hash).and_return("hashed_password_1", "hashed_password_2") }
    
    it "should hash the user's password" do
      user.save!
      user.hashed_password.should == "hashed_password_1" 
    end
  end
  
  describe ".generate_password_hash" do
    it "should MD5 hash the given password" do
      require 'digest/md5'
      User.generate_password_hash("secret").should == Digest::MD5.hexdigest("secret")
    end
  end
  
  describe ".authenticate" do
    it "should return false if the username does not match a valid user" do
      User.authenticate("username", "password").should == false
    end
    
    context "for a valid user" do
      let(:user) { User.make! }
      
      it "should return a user object if the given password matches the user's hashed password" do
        User.authenticate(user.username, user.password).should == user
      end
      
      it "should return false if the given password does not match the user's hashed password" do
        User.authenticate(user.username, "wrong password").should == false
      end
      
      it "should return false if given the hashed version of the password" do
        require 'digest/md5'
        User.authenticate(user.username, user.hashed_password).should == false
      end
    end
  end
end