Dir[File.join(File.dirname(__FILE__), "rails" ,"*.rb")].each do |file|
  require file
end
