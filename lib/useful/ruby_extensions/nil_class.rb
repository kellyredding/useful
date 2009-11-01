module Useful; end
module Useful::RubyExtensions; end

module Useful::RubyExtensions::NilClass
  
  module FromActivesupport

    def try(*args, &block)
      nil
    end unless nil.respond_to?('try')

    def to_boolean
      false
    end unless nil.respond_to?('to_boolean')

  end
  
  def self.included(receiver)
    receiver.send :include, FromActivesupport
  end
  
end

class NilClass
  include Useful::RubyExtensions::NilClass
end
