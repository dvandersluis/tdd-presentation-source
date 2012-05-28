require 'digest/md5'

class User < ActiveRecord::Base
  has_many :accounts
  
  attr_accessor :password
  
  before_save :set_hashed_password
  
  class << self
    def authenticate(username, password)
      user = User.find_by_username(username)
      return false unless user
      
      user.hashed_password == self.generate_password_hash(password) ? user : false
    end
    
    def generate_password_hash(password)
      Digest::MD5.hexdigest(password) 
    end  
  end
  
private
  def set_hashed_password
    self.hashed_password = User.generate_password_hash(self.password)  
  end
end