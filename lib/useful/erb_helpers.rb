Dir[File.join(File.dirname(__FILE__), "erb_helpers" ,"*.rb")].each do |file|
  require "useful/erb_helpers/#{File.basename(file, ".rb")}"
end
