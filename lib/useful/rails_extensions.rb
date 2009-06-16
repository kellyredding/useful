Dir[File.join(File.dirname(__FILE__), "rails_extensions" ,"*.rb")].each do |file|
  require file
end
