Dir[File.join(File.dirname(__FILE__), "active_record_helpers" ,"*.rb")].each do |file|
  require "useful/active_record_helpers/#{File.basename(file, ".rb")}"
end
