module Useful; end
module Useful::RubyExtensions; end

module Useful::RubyExtensions::Date
  
  def week_days_until(end_date)
    week_days = (1..5)
    raise ::ArgumentError, "End date cannot be nil." if end_date.nil?
    raise ::ArgumentError, "End date cannot come before questioned date." if end_date < self
    (self..end_date).to_a.select{|date| week_days.include?(date.wday)}.length
  end

end

class Date
  include Useful::RubyExtensions::Date
end
