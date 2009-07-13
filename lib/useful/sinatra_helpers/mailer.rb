Dir[File.join(File.dirname(__FILE__), "mailer" ,"*.rb")].each do |file|
  require file
end
