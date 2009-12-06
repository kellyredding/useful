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
  
  # return a Time object for the given Fixnum
  def to_time
    Time.at(self)
  end
  alias_method :to_time_at, :to_time
  
  module FromActivesupport
    # All methods here will yield to their Activesupport versions, if defined
    
    # Turns a number into an ordinal string used to denote the position in an
    # ordered sequence such as 1st, 2nd, 3rd, 4th.
    #
    # Examples:
    #   1.ordinalize     # => "1st"
    #   2.ordinalize     # => "2nd"
    #   1003.ordinalize  # => "1003rd"
    #   1004.ordinalize  # => "1004th"
    unless 1.respond_to?('ordinalize')
      def ordinalize
        if (11..13).include?(self.to_i % 100)
          "#{self}th"
        else
          case self.to_i % 10
            when 1; "#{self}st"
            when 2; "#{self}nd"
            when 3; "#{self}rd"
            else    "#{self}th"
          end
        end
      end
    end

  end
  
  def self.included(receiver)
    receiver.send :include, FromActivesupport
  end
  
end

class Fixnum
  include Useful::RubyExtensions::Fixnum
end
