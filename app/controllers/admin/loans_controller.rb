class Admin::LoansController < ApplicationController
    before_action :authenticate_user!
    before_action :check_admin
    before_action :set_loan, only: %i[approve reject adjust update_adjustment]
  
    def index
      @loans = Loan.requested
    end
  
    def approve
      if @loan.update(state: 'approved')
        redirect_to admin_loans_path, notice: 'Loan approved.'
      else
        redirect_to admin_loans_path, alert: 'Failed to approve loan.'
      end
    end
  
    def reject
      if @loan.update(state: 'rejected')
        redirect_to admin_loans_path, notice: 'Loan rejected.'
      else
        redirect_to admin_loans_path, alert: 'Failed to reject loan.'
      end
    end

    def adjust
      @loan_adjustment = LoanAdjustment.new
    end
  
    def update_adjustment
      @adjustment = @loan.loan_adjustments.build(adjustment_params.merge(admin: current_user))
      if @adjustment.save && @loan.update(state: 'waiting_for_adjustment_acceptance',principal_amount: adjustment_params[:new_principal], interest_rate: adjustment_params[:new_interest_rate])
        redirect_to admin_loans_path, notice: 'Loan adjustment done'
      else
        render :adjust
      end
    end
  
    private
  
    def set_loan
      @loan = Loan.find(params[:id])
    end
  
    def adjustment_params
      params.require(:loan_adjustment).permit(:new_principal, :new_interest_rate)
    end
  
    def check_admin
      redirect_to root_path, alert: 'Not authorized.' unless current_user.admin?
    end
  end
  