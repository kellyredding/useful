Dir[File.join(File.dirname(__FILE__), "ruby_extensions" ,"*.rb")].each do |file|
  require "useful/ruby_extensions/#{File.basename(file, ".rb")}"
end
