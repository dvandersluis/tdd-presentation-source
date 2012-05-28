require 'spec_helper'

def login
  visit "/login"
  fill_in "Username", :with => user.username
  fill_in "Password", :with => user.password
  click_button "Sign In"
end

describe AccountsController do
  let(:user) { User.make! }
  
  describe "GET deposit" do
    let(:account) { Account.make!(:user => user, :balance => 10000) }
    
    it "should add to the account's budget when submitting the form" do
      login
      visit "/accounts/#{account.id}/deposit"
      fill_in "Amount", :with => "1000"
      click_button "Deposit"
      page.should have_content "#{account.name} 11000"
    end
  end
end