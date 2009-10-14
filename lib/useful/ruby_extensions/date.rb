module Useful; end
module Useful::RubyExtensions; end

module Useful::RubyExtensions::Date
  
  WEEK_DAYS = (1..5)
  
  def week_days_between(end_date)
    raise ::ArgumentError, "End date cannot be nil." if end_date.nil?
    raise ::ArgumentError, "End date cannot come before questioned date." if end_date < self
    (self..end_date).to_a.select{|date| WEEK_DAYS.include?(date.wday)}.length
  end

end

class Date
  include Useful::RubyExtensions::Date
end
