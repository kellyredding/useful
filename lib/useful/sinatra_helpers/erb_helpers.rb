require 'sinatra/base'

require "useful/erb_helpers"
Sinatra::Application.helpers Useful::ErbHelpers::Forms
Sinatra::Application.helpers Useful::ErbHelpers::Links
Sinatra::Application.helpers Useful::ErbHelpers::Partials
Sinatra::Application.helpers Useful::ErbHelpers::Tags

