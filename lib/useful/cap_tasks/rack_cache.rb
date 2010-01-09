unless Capistrano::Configuration.respond_to?(:instance)
  abort "useful/cap_tasks requires Capistrano 2"
end

Capistrano::Configuration.instance.load do

  namespace :deploy do

    after 'deploy:setup', 'deploy:create_apache_log_folder'
    after 'deploy:update_code', 'deploy:link_cache_folders'

    desc '_: (useful) Creates the shared cache folders'
    task :create_cache_folders, :roles => :app, :except => { :no_release => true } do 
      run "mkdir -p #{shared_path}/cache; chmod 775 #{shared_path}/cache"
      run "mkdir -p #{shared_path}/cache-rack; chmod 775 #{shared_path}/cache-rack"
    end

    desc '_: (useful) Links the shared cache folders into the public directory'
    task :link_cache_folders, :roles => :app, :except => { :no_release => true } do 
      run "ln -s #{shared_path}/cache #{release_path}/public"
      run "ln -s #{shared_path}/cache-rack #{release_path}"
    end

  end
  
  namespace :cache do

    desc "_: (useful) Clear the rack cache"
    task :xrack, :roles => :app, :except => { :no_release => true } do
      run "rm -rf #{shared_path}/cache-rack/body/*"
      run "rm -rf #{shared_path}/cache-rack/meta/*"
    end

  end

end
