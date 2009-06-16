Dir[File.join(File.dirname(__FILE__), "sinatra_helpers" ,"*.rb")].each do |file|
  require file
end
