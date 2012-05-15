module ApplicationHelper
  def display_account_name_to_and_or_from(trans)
    name = ''
    name << "from #{trans.account_from.name}" if trans.respond_to? :account_from
    name << "to #{trans.account_to.name}" if trans.respond_to? :account_to
    name.sub!(/^(to|from) /, '') unless trans.is_a?(Transfer) || trans.is_a?(VirtualTransfer)
    name.html_safe
  end
end
