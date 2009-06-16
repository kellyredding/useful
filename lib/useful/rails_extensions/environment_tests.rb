module Useful
  module RailsExtensions
    module EnvironmentTests
      
      module ClassMethods
        
        def production? 
          RAILS_ENV == 'production'
        end
        
        def development? 
          RAILS_ENV == 'development'
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
