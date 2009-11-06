unless Capistrano::Configuration.respond_to?(:instance)
  abort "useful/cap_tasks requires Capistrano 2"
end

Capistrano::Configuration.instance.load do

  namespace :cache do
  
    desc "Clear the Rack cache"
    task :xrack, :roles => :app, :except => { :no_release => true } do
      run "rm -rf #{shared_path}/cache-rack/body/*"
      run "rm -rf #{shared_path}/cache-rack/meta/*"
    end

  end

end
