class PurchasesController < ApplicationController
  
  def new
  end
  
  def new_from_virtual_account
    @virtual_account = VirtualAccount.find_by_name(params[:name])
    @spending_accounts = Account.spending_accounts
    @vendors = Vendor.all
    @purchase = Purchase.new_from_virtual_account(@virtual_account)
  end
  
  def new_from_expected_purchase
    @expected_purchase = ExpectedPurchase.find_by_id(params[:id])
    kick_out and return if @expected_purchase.nil?
    @virtual_account = @expected_purchase.virtual_account
    @spending_accounts = Account.spending_accounts
    @vendors = Vendor.all
    @purchase = Purchase.new_from_expected_purchase(@expected_purchase)

    render 'new_from_virtual_account'
  end
  
  def create
    if @purchase = Purchase.create(params[:purchase])
      respond_to do |format|
        format.html {
          flash[:notice] = "Purchase saved: #{purchase_amounts_in_words_from(@purchase)}."
          redirect_to new_purchase_path
        }
        # format.json { render :status => 201, :json => @purchase.to_json(:include => vendor) }
      end
    else
      respond_to do |format|
        format.html {
          @virtual_account = @expected_purchase.virtual_account
          @spending_accounts = Account.spending_accounts
          @payees = Vendor.all
          flash[:error] = 'Could not save purchase because of errors'
          render 'new_from_expected_purchase'
        }
        # format.json { render :status => 400, :json => @purchase.errors.to_json }
      end
    end
  end
  
  private
  
  def kick_out
    flash[:notice] = 'That transaction has been completed!'
    redirect_to :action => 'new'
  end
  
  def purchase_amounts_in_words_from(purchase)
    purchase.virtual_purchases.map{ |vp| "$#{vp.amount} from '#{vp.account_from.name}'" }.join(' and ')
  end
end