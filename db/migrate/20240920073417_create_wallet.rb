class CreateWallet < ActiveRecord::Migration[7.1]
  def change
    create_table :wallets do |t|
      t.decimal :balance, precision: 10, scale: 2, default: 10000
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
