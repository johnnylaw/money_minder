class PurchasesController < ApplicationController
  
  def new
  end
  
  def new_from_virtual_account
    @virtual_account = VirtualAccount.find_by_name(params[:name])
    @spending_accounts = PhysicalAccount.spending_accounts
    @payees = Vendor.all
    @purchase = Purchase.new
  end
  
  def new_for_expected_purchase
    @expected_purchase = ExpectedPurchase.find_by_id(params[:id])
    kick_out and return if @expected_purchase.nil?
    @virtual_account = @expected_purchase.recipe.virtual_accounts.first #portions.first.virtual_account
    @spending_accounts = Account.spending_accounts
    @payees = Vendor.all
    @purchase = Purchase.new_for_expected_purchase(@expected_purchase)

    render 'new_from_virtual_account'
  end
  
  def create
    @purchase = Purchase.new(params[:purchase])
    # raise @purchase.executed_at.inspect
    if @purchase.save
      flash[:notice] = "Purchase saved: #{@purchase.amount} from #{@purchase.virtual_purchases.first.account_from.name}."
      redirect_to new_purchase_path
    else
      flash[:error] = 'Could not save purchase because of errors'
      render 'new'
    end
  end
  
  private
  
  def kick_out
    flash[:notice] = 'That transaction has been completed!'
    redirect_to :action => 'new'
  end
end