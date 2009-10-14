module Useful; end
module Useful::RubyExtensions; end

module Useful::RubyExtensions::Object
  
  def false?
    self == false
  end
  
  def true?
    self == true
  end
  
end

class Object
  include Useful::RubyExtensions::Object
end
