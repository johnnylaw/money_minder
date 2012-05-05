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
    # raise @expected_revenue.unused_virtual_accounts.inspect
  end
  
  def show
    @transaction = Revenue.find(params[:id])
    @virtual_transactions = @transaction.virtual_revenues
    
    render 'purchases/show'
  end
  
  def create
    @revenue = Revenue.new(params[:revenue])
    # @revenue.executed_at = Time.parse('2012-03-28 00:00:00') # put in as a momentary band-aid
    @revenue.save
  end
  
  def kick_out
    redirect_to :new_purchase
  end
end