class CreateLoanAdjustment < ActiveRecord::Migration[7.1]
  def change
    create_table :loan_adjustments do |t|
      t.references :loan, foreign_key: true
      t.references :admin, foreign_key: { to_table: :users }
      t.decimal :new_principal, precision: 10, scale: 2
      t.decimal :new_interest_rate, precision: 5, scale: 2
      t.integer :status, default: 0
      t.timestamps
    end
  end
end
