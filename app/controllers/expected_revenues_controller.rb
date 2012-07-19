class ExpectedRevenuesController < ApplicationController
  def index
    @expected_revenues = ExpectedRevenue.outstanding.current
    respond_to do |format|
      format.html {}
      format.json { render :json => jsonified_expected_revenues }
    end
  end
  
  private
  
  def jsonified_expected_revenues
    @expected_revenues.map{ |rev| rev.attributes.merge(
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