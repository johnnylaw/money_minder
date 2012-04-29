class VirtualAccountsController < ApplicationController
  def index
    @virtual_accounts = VirtualAccount.all
    
    respond_to do |format|
      format.html {}
      format.json { render :json => jsonified_virtual_accounts }
    end
  end
  
  def show
    @virtual_account = VirtualAccount.find_by_name(params[:name])
  end
  
  private
  
  def jsonified_virtual_accounts
    @virtual_accounts.map{ |acct| acct.attributes.merge( 
      'balance' => acct.balance.to_s, 'new_purchase_href' => new_purchase_from_virtual_account_path(acct),
      'href'  => virtual_account_path(acct)
    ) }.to_json
  end
end