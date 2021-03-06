module Useful; end
module Useful::RubyExtensions; end

module Useful::RubyExtensions::FalseClass
  
  def to_affirmative(abbreviate=false)
    abbreviate ? "N" : "No"
  end
  alias :to_casual_s :to_affirmative

  def to_i
    0
  end
  
  def to_boolean
    false
  end

end

class FalseClass
  include Useful::RubyExtensions::FalseClass
end
