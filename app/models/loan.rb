# app/models/loan.rb
class Loan < ApplicationRecord
    belongs_to :user
    belongs_to :admin, class_name: 'User'
  
    has_many :loan_adjustments, dependent: :destroy
  
    enum state: { requested: 0, approved: 1, open: 2, closed: 3, rejected: 4, waiting_for_adjustment_acceptance: 5, readjustment_requested: 6 }
  
    validates :principal_amount, :interest_rate, presence: true
  
    after_update :debit_admin_and_credit_user, if: :open?
  
    private
  
    # Handle the money transfer once the loan is open
    def debit_admin_and_credit_user
      if state == 'open'
        Loan.transaction do
          admin.wallet.update!(balance: admin.wallet.balance - principal_amount)
          user.wallet.update!(balance: user.wallet.balance + principal_amount)
        end
      end
    end
  end
  