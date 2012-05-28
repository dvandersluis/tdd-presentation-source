class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.integer :user_id, :null => false
      t.string :name, :null => false
      t.decimal :balance, :default => 0.0
    end
  end
end
