class AccountsController < ApplicationController
  def index
    @accounts = Account.all
    @virtual_accounts = VirtualAccount.all
  end
  
  def show
    @account = Account.find_by_name(params[:name])
  end
  
  def new
    @account = Account.new
    @holding_accounts = Account.holding_accounts
  end
end