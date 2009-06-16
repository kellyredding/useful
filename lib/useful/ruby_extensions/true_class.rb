module Useful
  module RubyExtensions
    module TrueClass
      
      def to_affirmative
        "Yes"
      end
      alias :to_casual_s :to_affirmative

      def to_i
        1
      end
    
    end
  end
end

class TrueClass
  include Useful::RubyExtensions::TrueClass
end
