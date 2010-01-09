unless Capistrano::Configuration.respond_to?(:instance)
  abort "useful/cap_tasks requires Capistrano 2"
end

Capistrano::Configuration.instance.load do

  namespace :cache do
  
    after 'deploy:setup', 'deploy:create_apache_log_folder'

    desc '_: (useful) Creates the shared cache folders'
    task :create_cache_folders, :roles => :app do 
      run "mkdir -p #{shared_path}/cache; chmod 775 #{shared_path}/cache"
      run "mkdir -p #{shared_path}/cache-rack; chmod 775 #{shared_path}/cache-rack"
    end

    desc "_: (useful) Clear the rack cache"
    task :xrack, :roles => :app, :except => { :no_release => true } do
      run "rm -rf #{shared_path}/cache-rack/body/*"
      run "rm -rf #{shared_path}/cache-rack/meta/*"
    end

  end

end
