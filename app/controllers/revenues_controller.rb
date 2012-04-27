class RevenuesController < ApplicationController
  def new_from_expected_revenue
    @expected_revenue = ExpectedRevenue.find_by_id(params[:id])
    # raise @expected_revenue.recipe.inspect
    kick_out and return if @expected_revenue.nil?
    @holding_accounts = Account.holding_accounts
    @customers = Customer.all
    @revenue = Revenue.new_from_expected_revenue(@expected_revenue)
    # raise @revenue.virtual_revenues.inspect
  end
end