Dir[File.join(File.dirname(__FILE__), "ruby_extensions_from_rails" ,"*.rb")].each do |file|
  require "useful/ruby_extensions_from_rails/#{File.basename(file, ".rb")}"
end
