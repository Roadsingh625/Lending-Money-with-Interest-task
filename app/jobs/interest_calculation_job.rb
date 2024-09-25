# app/jobs/interest_calculation_job.rb
class InterestCalculationJob < ApplicationJob
  queue_as :default

  def perform
    Loan.open.each do |loan|
      interest = loan.principal_amount * (loan.interest_rate / 100.0)
      loan.update(total_amount: (loan.total_amount + interest))
    end
  end
end
