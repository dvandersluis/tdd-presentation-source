class AccountsController < ApplicationController
  before_filter :redirect_if_not_logged_in
  before_filter :find_account, :except => [:index]
  
  def index
    @accounts = current_user.accounts
  end
  
  def deposit
    if request.post?
      @account.deposit(params[:amount])
      flash[:notice] = t(:successful_deposit)
      redirect_to :action => :index and return
    end
  end
  
  def withdraw
    if request.post?
      begin
        @account.withdraw(params[:amount])
        flash[:notice] = t(:successful_withdrawal)
      rescue Exception => e
        flash[:error] = e.message
      end
      
      redirect_to :action => :index and return 
    end
  end
  
  def transfer
    if request.post?
      begin
        @account.transfer(params[:amount], Account.find(params[:recipient]))
        flash[:notice] = t(:successful_transfer)
      rescue Exception => e
        flash[:error] = e.message
      end
      
      redirect_to :action => :index and return
    end
    
    @recipients = current_user.accounts.where(["id != ?", @account.id])
  end

private
  def find_account
    @account = Account.find(params[:id])
  end
  
  def redirect_if_not_logged_in
    redirect_to login_path unless current_user
  end
end