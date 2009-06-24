Dir[File.join(File.dirname(__FILE__), "tags" ,"*.rb")].each do |file|
  require file
end
