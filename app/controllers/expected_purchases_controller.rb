class ExpectedPurchasesController < ApplicationController
  def index
    @expected_purchases = ExpectedPurchase.all
    respond_to do |format|
      format.html {}
      format.json { render :json => jsonified_upcoming_transactions }
    end
  end
  
  def dismiss
    upcoming_transaction = UpcomingTransaction.find_by_id(params[:id])
    upcoming_transaction.update_attribute(:was_dismissed, true) if upcoming_transaction
    flash[:notice] = 'Transaction dismissed'
    redirect_to new_purchase_path
  end
  
  private
  
  def jsonified_upcoming_transactions
    @expected_purchases.map{ |pur| pur.attributes.merge(
      'due_in' => distance_of_time_in_words_until(pur.scheduled_on, pur.scheduled_for_hour),
      'new_purchase_url' => new_purchase_for_expected_purchase_path(pur),
      'weekday' => pur.scheduled_on.strftime('%A'),
      'dismiss_url' => expected_purchase_path(pur),
      'is_promised' => pur.recipe.is_promised,
      'name' => pur.recipe.name, 'payee_name' => pur.recipe.vendor_name, 
      'amount' => pur.recipe.cents.to_s
    ) }.to_json
  end
  
  def distance_of_time_in_words_until(date, hour)
    seconds = date.to_time + hour.hours - Time.now
    words = ActionView::Base.new.distance_of_time_in_words(seconds)
    if seconds < 0
      return "#{words} ago"
    else
      return "in #{words}"
    end
  end
  
end