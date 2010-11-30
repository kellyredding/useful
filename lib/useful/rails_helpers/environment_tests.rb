module Useful; end
module Useful::RailsExtensions; end

module Useful::RailsExtensions::EnvironmentTests
  
  module ClassMethods
    
    def production? 
      Rails.env == 'production'
    end
    
    def development? 
      Rails.env == 'development'
    end
    
  end
  
  module InstanceMethods
    
    def production? 
      self.class.production?
    end
    
    def development? 
      self.class.development?
    end
    
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end

end

module ActiveRecord
  class Base
    include Useful::RailsExtensions::EnvironmentTests
  end
  class Observer
    include Useful::RailsExtensions::EnvironmentTests
  end
end
module ActionController
  class Base
    include Useful::RailsExtensions::EnvironmentTests
  end
end
module ActionView
  class Base
    include Useful::RailsExtensions::EnvironmentTests
  end
end
module ActionMailer
  class Base
    include Useful::RailsExtensions::EnvironmentTests
  end
end
