class Account < ActiveRecord::Base
  belongs_to :user
  
  def deposit(amt)
    amt = amt.to_f
    self.balance += amt
    save
  end
  
  def withdraw(amt)
    amt = amt.to_f
    raise "cannot withdraw more than #{self.balance}" if amt > self.balance
    raise "can only withdraw in multiples of 20 or 50" unless amt % 20.0 == 0.0 or amt % 50.0 == 0.0
    self.balance -= amt
    save
  end
  
  def transfer(amt, receiver)
    amt = amt.to_f
    raise "cannot transfer more than #{self.balance}" if amt > self.balance
    self.balance -= amt
    save
    receiver.balance += amt
    receiver.save
  end
end