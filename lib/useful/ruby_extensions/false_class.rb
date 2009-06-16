module Useful
  module RubyExtensions
    module FalseClass
      
      def to_affirmative
        "No"
      end
      alias :to_casual_s :to_affirmative

      def to_i
        0
      end
    
    end
  end
end

class FalseClass
  include Useful::RubyExtensions::FalseClass
end
