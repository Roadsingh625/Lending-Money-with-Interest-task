class CreateLoan < ActiveRecord::Migration[7.1]
  def change
    create_table :loans do |t|
      t.references :user, foreign_key: true
      t.references :admin, foreign_key: { to_table: :users }
      t.decimal :principal_amount, precision: 10, scale: 2
      t.decimal :interest_rate, precision: 5, scale: 2
      t.decimal :total_amount, precision: 10, scale: 2, default: 0
      t.integer :state, default: 0
      t.integer :adjustment_count, default: 0
      t.timestamps
    end
  end
end
