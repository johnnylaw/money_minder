class VirtualAccountsController < ApplicationController
  def index
    @virtual_accounts = VirtualAccount.all
    
    respond_to do |format|
      format.html {}
      format.json { render :json => @virtual_accounts }
    end
  end
  
  def show
    @account = VirtualAccount.find_by_name(params[:name])
    
    render 'accounts/show'
  end
  
  def new
    @account = VirtualAccount.new
    @spending_accounts = Account.spending_accounts
    
    render 'accounts/new'
  end
  
  def create
    @account = VirtualAccount.find_or_initialize_by_name(params[:virtual_account])
    if @account.save
      flash[:notice] = "Successfully created the `#{@account.name}` Virtual Account."
      redirect_to accounts_path
    else
      flash[:error] = 'There were problems creating the new Virtual Account.'
      render 'accounts/new'
    end
  end
  
end