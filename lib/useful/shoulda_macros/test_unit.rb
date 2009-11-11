Dir[File.join(File.dirname(__FILE__), "test_unit" ,"*.rb")].each do |file|
  require "useful/shoulda_macros/test_unit/#{File.basename(file, ".rb")}"
end
