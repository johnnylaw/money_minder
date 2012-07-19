class ExpectedPurchasesController < ApplicationController
  def index
    @expected_purchases = ExpectedPurchase.outstanding
    respond_to do |format|
      format.html {}
      format.json { render :json => jsonified_expected_purchases }
    end
  end
  
  def dismiss
    expected_purchase = ExpectedPurchase.find_by_id(params[:id])
    expected_purchase.update_attribute(:is_complete, true) if expected_purchase
    flash[:notice] = 'Transaction dismissed'
    redirect_to new_purchase_path
  end
  
  private
  
  def jsonified_expected_purchases
    @expected_purchases.select{ |p| p.current? }.map{ |pur| pur.attributes.merge(
      'due_in' => distance_of_time_in_words_until(pur.scheduled_on, pur.scheduled_for_hour),
      'status' => pur.status,
      'new_purchase_url' => new_purchase_from_expected_purchase_path(pur),
      # 'weekday' => pur.scheduled_on.strftime('%a, %b %d'),
      # 'due_in' => pur.scheduled_on.strftime('%a, %b %d'),
      'dismiss_url' => expected_purchase_path(pur),
      'is_promised' => pur.recipe.is_promised?,
      'name' => pur.recipe.name, 'vendor_name' => pur.recipe.vendor_name, 
      'amount' => pur.recipe.amount
    ) }.to_json
  end  
end