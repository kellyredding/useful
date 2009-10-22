Dir[File.join(File.dirname(__FILE__), "sinatra_helpers" ,"*.rb")].each do |file|
  require "useful/sinatra_helpers/#{File.basename(file, ".rb")}"
end
