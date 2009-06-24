require 'sinatra/base'

module Useful
  module SinatraHelpers
    module Erb
      module ErrorPages
        
        def self.registered(app)
          app.configure :production do
            app.not_found do
              erb :'404.html'
            end
            app.error do
              @err = request.env['sinatra_error']
              erb :'500.html'
            end
          end
        end
        
      end
    end
  end
end

Sinatra::Application.register Useful::SinatraHelpers::Erb::ErrorPages
