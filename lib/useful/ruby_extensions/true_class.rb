module Useful; end
module Useful::RubyExtensions; end

module Useful::RubyExtensions::TrueClass
  
  def to_affirmative(abbreviate=false)
    abbreviate ? "Y" : "Yes"
  end
  alias :to_casual_s :to_affirmative

  def to_i
    1
  end
  
  def to_boolean
    true
  end

end

class TrueClass
  include Useful::RubyExtensions::TrueClass
end
