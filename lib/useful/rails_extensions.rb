Dir[File.join(File.dirname(__FILE__), "rails_extensions" ,"*.rb")].each do |file|
  require "useful/rails_extensions/#{File.basename(file, ".rb")}"
end
