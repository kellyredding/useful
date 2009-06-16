module Useful
  module RubyExtensions
    module ObjectExt
      
      def false?
        self == false
      end
      
      def true?
        self == true
      end
      
    end
  end
end

class Object
  include Useful::RubyExtensions::ObjectExt
end
