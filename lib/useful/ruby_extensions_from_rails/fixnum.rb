module Useful
  module RubyExtensionsFromRails
    module Fixnum
      
      # Turns a number into an ordinal string used to denote the position in an
      # ordered sequence such as 1st, 2nd, 3rd, 4th.
      #
      # Examples:
      #   1.ordinalize     # => "1st"
      #   2.ordinalize     # => "2nd"
      #   1003.ordinalize  # => "1003rd"
      #   1004.ordinalize  # => "1004th"
      def ordinalize
        if (11..13).include?(self.to_i % 100)
          "#{number}th"
        else
          case self.to_i % 10
            when 1; "#{number}st"
            when 2; "#{number}nd"
            when 3; "#{number}rd"
            else    "#{number}th"
          end
        end
      end

    end
  end
end

class Fixnum
  include Useful::RubyExtensionsFromRails::Fixnum
end
