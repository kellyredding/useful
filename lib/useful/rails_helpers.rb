Dir[File.join(File.dirname(__FILE__), "rails_helpers" ,"*.rb")].each do |file|
  require "useful/rails_helpers/#{File.basename(file, ".rb")}"
end
