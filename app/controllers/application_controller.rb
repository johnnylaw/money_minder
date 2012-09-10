class ApplicationController < ActionController::Base
  require 'bcrypt'
  
  protect_from_forgery
  
  before_filter :authenticate
  before_filter :assign_iphone_user_agent
  
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      enc_str = YAML.load_file(Rails.root + 'config/auth.yml')['enc_str']
      BCrypt::Password.new(enc_str) == "#{username}:#{password}"
    end
  end
  
  def assign_iphone_user_agent
    @iphone = request.user_agent.match /iPhone/
  end
  
  def distance_of_time_in_words_until(date, hour)
    now = Time.zone.now
    seconds = date.to_time + hour.hours - now
    #TODO: put this somewhere else and fix the today/tomorrow/yesterday thing
    return 'today' if date == now.to_date
    return 'tomorrow' if date == (now + 1.day).to_date
    return 'yesterday' if date == (now - 1.day).to_date
    words = ActionView::Base.new.distance_of_time_in_words(seconds).sub(/about /, '~')
    if seconds < 0
      return "#{words} ago"
    else
      return "in #{words}"
    end
  end
    
end
