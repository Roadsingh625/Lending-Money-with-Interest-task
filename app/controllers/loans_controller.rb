class LoansController < ApplicationController
    before_action :authenticate_user!
    before_action :set_loan, only: %i[show confirm repay accept_adjustment reject_adjustment]
  
    def index
      @loans = current_user.loans.where.not(state: 'closed')
    end
  
    def new
      @loan = Loan.new
    end
  
    def create
      @loan = current_user.loans.build(loan_params.merge(admin: User.find_by(admin: true)))
      if @loan.save
        redirect_to loans_path, notice: 'Loan request submitted.'
      else
        render :new
      end
    end
  
    def show
    end
  
    def confirm
      if @loan.update(state: 'open',total_amount: @loan.principal_amount)
        render :show
      else
        render :show
      end
    end
  
    def repay
      if @loan.open?
        Loan.transaction do
          amount = [current_user.wallet.balance, @loan.total_amount].min
          current_user.wallet.update!(balance: current_user.wallet.balance - amount)
          @loan.admin.wallet.update!(balance: @loan.admin.wallet.balance + amount)
          @loan.update!(state: 'closed', total_amount: @loan.total_amount - amount)
        end
        redirect_to loans_path, notice: 'Loan repaid.'
      else
        redirect_to loans_path, alert: 'Loan cannot be repaid.'
      end
    end

    def accept_adjustment
      if @loan.update(state: 'open', total_amount: @loan.loan_adjustments.last.new_principal)
        redirect_to loans_path, notice: 'Loan adjustment accepted.'
      else
        redirect_to loans_path, alert: 'Failed to accept adjustment.'
      end
    end
  
    def reject_adjustment
      if @loan.update(state: 'rejected')
        redirect_to loans_path, notice: 'Loan adjustment rejected.'
      else
        redirect_to loans_path, alert: 'Failed to reject adjustment.'
      end
    end
  
    private
  
    def loan_params
      params.require(:loan).permit(:principal_amount, :interest_rate)
    end
  
    def set_loan
      @loan = Loan.find(params[:id])
    end
  end
  