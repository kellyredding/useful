module Useful; end
module Useful::ShouldaMacros; end
module Useful::ShouldaMacros::TestUnit; end

module Useful::ShouldaMacros::TestUnit::Context  
end


if defined? Shoulda::Context
  module Shoulda
    class Context
  
      alias_method :before, :setup
      alias_method :after, :teardown
      
    end
  end

  Shoulda::Context.extend(Useful::ShouldaMacros::TestUnit::Context)
end
