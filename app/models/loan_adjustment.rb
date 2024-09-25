# app/models/loan_adjustment.rb
class LoanAdjustment < ApplicationRecord
    belongs_to :loan
    belongs_to :admin, class_name: 'User'
  
    validates :new_principal, :new_interest_rate, presence: true
  end
  