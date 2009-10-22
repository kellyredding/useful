require 'sinatra/base'

module Useful; end
module Useful::SinatraHelpers; end

module Useful::SinatraHelpers::EnvironmentTests
    
  def production? 
    Sinatra::Application.environment.to_s == 'production'
  end
  def development?
    Sinatra::Application.environment.to_s == 'development'
  end
  
end

Sinatra::Application.helpers Useful::SinatraHelpers::EnvironmentTests
Sinatra::Application.register Useful::SinatraHelpers::EnvironmentTests
