namespace :cache do
  
  desc "Clear the Rack cache"
  task :xrack, :roles => :app, :except => { :no_release => true } do
    run "rm -rf #{shared_path}/cache-rack/body/*"
    run "rm -rf #{shared_path}/cache-rack/meta/*"
  end

end
