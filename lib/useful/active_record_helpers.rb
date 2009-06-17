Dir[File.join(File.dirname(__FILE__), "active_record_helpers" ,"*.rb")].each do |file|
  require file
end
