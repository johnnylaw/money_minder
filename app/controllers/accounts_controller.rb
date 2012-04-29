class AccountsController < ApplicationController
  def index
    @accounts = Account.all
    @virtual_accounts = VirtualAccount.all
  end
  
  def show
    @account = Account.find_by_name(params[:name])
  end
end