require 'sinatra/base'

module Sinatra
  module SinatraHelpers
    module EnvironmentTests
      def production? 
        Sinatra::Application.environment.to_s == 'production'
      end
      def development?
        Sinatra::Application.environment.to_s == 'development'
      end
    end
  end
  
  Sinatra::Application.helpers Sinatra::SinatraHelpers::EnvironmentTests
  Sinatra::Application.register Sinatra::SinatraHelpers::EnvironmentTests
end
