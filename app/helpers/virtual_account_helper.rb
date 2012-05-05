module VirtualAccountHelper
  def display_amount(trans, virtual_account_id = nil)
    if trans.respond_to?(:account_from_id)
      if virtual_account_id.nil? || trans.account_from_id == virtual_account_id
        display_money(-trans.amount)
      end
    elsif trans.respond_to?(:account_to_id)
      if virtual_account_id.nil? || trans.account_to_id == virtual_account_id
        display_money(trans.amount)
      end
    end
  end
  
  def display_money(amt)
    if amt < 0
      "<span class=\"negative\">($#{-amt})</span>".html_safe
    else
      "<span class=\"positive\">$#{amt}</span>".html_safe
    end
  end
  
  def display_inside_account_name(trans)
    if trans.is_a? Purchase
      html = "from <em>#{trans.account_from.name}</em>"
    elsif trans.is_a? Revenue
      html = "into <em>#{trans.account_to.name}</em>"
    else # Transfer or Virtual Transfer
      html = "transfered from <em>#{trans.account_from.name}</em> to <em>#{trans.account_to.name}</em>"
    end
    html.html_safe
  end
  
  def transaction_title_span(trans, acct_id = nil)
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
    %{<span class="title">#{title}</span>}.html_safe
  end
  
  def transaction_subtitle_span(trans)
    %{<span class="subtitle">#{trans.memo}</span>}.html_safe
  end
  
  def transaction_description(trans, acct_id = nil)
    html = transaction_title_span(trans, acct_id)
    html << "\n<br />\n".html_safe
    html << transaction_subtitle_span(trans)
  end
  
  def computed_transaction_path(trans)
    if trans.is_a? VirtualRevenue
      revenue_path(trans.revenue)
    elsif trans.is_a? VirtualPurchase
      purchase_path(trans.purchase)
    elsif trans.is_a? Revenue
      revenue_path(trans)
    elsif trans.is_a? Purchase
      purchase_path(trans)
    elsif trans.is_a? Transfer
      transfer_path(trans)
    elsif trans.is_a? VirtualTransfer
      virtual_transfer_path(trans)
    end
  end
end
