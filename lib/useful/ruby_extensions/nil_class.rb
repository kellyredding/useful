module Useful; end
module Useful::RubyExtensions; end

module Useful::RubyExtensions::NilClass
  
  module FromActivesupport

    def try(*args, &block)
      nil
    end unless nil.respond_to?('try')

  end
  
  def self.included(receiver)
    receiver.send :include, FromActivesupport
  end
  
end

class NilClass
  include Useful::RubyExtensions::NilClass
end
