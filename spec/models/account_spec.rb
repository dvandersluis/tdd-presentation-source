require 'spec_helper'

describe Account do
  let(:user) { User.make! }
  let(:account) { Account.make(:user => user) }
  
  describe "#deposit" do
    it "should add the deposit amount to the balance" do
      account.deposit(50.0)
      account.balance.should == 150.0
    end
  end
  
  describe "#withdraw" do
    it "should subtract the withdrawal from the balance" do
      account.withdraw(50.0)
      account.balance.should == 50.0
    end
    
    it "should raise an error if trying to withdraw more than the account balance" do
      expect { account.withdraw(200.0) }.to raise_error
    end
    
    xit "should only allow withdrawals in multiples of 20.0 or 50.0" do
      account.balance = 2000
      expect { account.withdraw(45) }.to raise_error
      expect { account.withdraw(40) }.to_not raise_error
      expect { account.withdraw(100) }.to_not raise_error
      expect { account.withdraw(150) }.to_not raise_error
      expect { account.withdraw(20) }.to_not raise_error
      expect { account.withdraw(50) }.to_not raise_error
    end
  end
  
  describe "#transfer" do
    let(:account2) { Account.make(:user => user) }
    
    it "should subtract the transfer from the originating account and add it to the receiving account" do
      original_balances = [account.balance, account2.balance]
      account.transfer(75.0, account2)
      account.balance.should == original_balances.first - 75.0
      account2.balance.should == original_balances.second + 75.0
    end
    
    it "should raise an error if trying to transfer more than there is in the originating account" do
      expect { account.transfer(200.0, account2) }.to raise_error
    end
  end
end