module Useful
  module RubyExtensionsFromRails
    module ObjectExt
      
      def blank?
        self.nil? || (self.respond_to?(:empty?) ? self.empty? : false)
      end

    end
  end
end

class Object
  include Useful::RubyExtensionsFromRails::ObjectExt
end
