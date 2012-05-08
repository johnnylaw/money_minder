class RevenuesController < ApplicationController
  def new
    @customers = Customer.all
    @holding_accounts = Account.holding_accounts
    @revenue = Revenue.new
    @virtual_accounts = VirtualAccount.all
    4.times { @revenue.virtual_revenues.build }
  end
  
  def new_from_expected_revenue
    @expected_revenue = ExpectedRevenue.outstanding.find_by_id(params[:id])
    kick_out and return if @expected_revenue.nil?
    @holding_accounts = Account.holding_accounts
    @customers = Customer.all
    @revenue = Revenue.new_from_expected_revenue(@expected_revenue)
  end
  
  def show
    @transaction = Revenue.find(params[:id])
    @virtual_transactions = @transaction.virtual_revenues
    
    render 'purchases/show'
  end
  
  def create
    @revenue = Revenue.new(params[:revenue])
    if @revenue.save
      flash[:notice] = "Revenue transaction for $#{@revenue.amount} saved"
      redirect_to accounts_path
    else
      flash[:error] = 'Could not save revenue transaction because of errors'
      @holding_accounts = Account.holding_accounts
      if @revenue.expected_revenue
        @expected_revenue = @revenue.expected_revenue
        render 'new'
      else
        @virtual_accounts = @revenue.virtual_revenues.map(&:account_to)
        render 'new_from_expected_revenue'
      end
    end
  end
  
  def kick_out
    redirect_to :new_purchase
  end
end