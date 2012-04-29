module VirtualAccountHelper
  def display_amount(trans, virtual_account_id)
    if trans.respond_to?(:account_from_id) && trans.account_from_id == virtual_account_id
      "<span class=\"negative\">($#{trans.amount})</span>".html_safe
    elsif trans.respond_to?(:account_to_id) && trans.account_to_id == virtual_account_id
      "<span class=\"positive\">$#{trans.amount}</span>".html_safe
    end
  end
  
  def transaction_description(trans, acct_id)
    if trans.is_a? VirtualPurchase
      title = trans.purchase.vendor.name
    elsif trans.is_a? VirtualRevenue
      title = trans.revenue.customer.name
    elsif trans.is_a? Purchase
      title = trans.vendor.name
    elsif trans.is_a? Revenue
      title = trans.customer.name
    else
      title = "Transfer "
      if trans.account_from_id == acct_id
        title += "to <em>#{trans.account_to.name}</em>"
      else
        title += "from <em>#{trans.account_from.name}</em>"
      end
    end
    html = %{<span class="title">#{title}</span>\n<br />}
    html << %{<span class="subtitle">#{trans.memo}</span>}
    html.html_safe
  end
end
