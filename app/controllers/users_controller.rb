class UsersController < ApplicationController
  def login
    redirect_to(accounts_path) and return if session[:user_id]
    
    if request.post?
      @user = User.authenticate(params[:username], params[:password])
      
      if @user
        session[:user_id] = @user.id
        redirect_to accounts_path and return
      else
        flash[:error] = t(:invalid_username_or_password)
      end
    end
    
    @user = User.new
  end
  
  def logout
    session[:user_id] = nil
    redirect_to login_path
  end
end