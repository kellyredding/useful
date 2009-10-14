module Useful; end
module Useful::RubyExtensions; end

module Useful::RubyExtensions::Fixnum
  
  # returns a string reprensentation of the number padded with pad_num to a specified length
  def pad(length = 3, pad_num = 0)
    self.to_s.rjust(length,pad_num.to_s) rescue self.to_s
  end

  # return the value in values that is nearest to the number
  def to_nearest_value(values = [])
    return self if values.length == 0
    value = values.first.to_i rescue self
    diff = (self-value).abs
    values.each do |val|
      if (self-val.to_i).abs < diff
        diff = (self-val.to_i).abs
        value = val.to_i
      end
    end
    value
  end
  
end

class Fixnum
  include Useful::RubyExtensions::Fixnum
end
