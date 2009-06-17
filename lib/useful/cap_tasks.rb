Dir[File.join(File.dirname(__FILE__), "cap_tasks" ,"*.rb")].each do |file|
  require file
end
