unless Capistrano::Configuration.respond_to?(:instance)
  abort "useful/cap_tasks requires Capistrano 2"
end

Capistrano::Configuration.instance.load do

  namespace :deploy do

    after 'deploy:setup', 'deploy:create_apache_log_folder'
    after 'deploy',       'deploy:cleanup_deploy'

    desc '_: (useful) Create the shared log/apache2 folder'
    task :create_apache_log_folder, :roles => :app, :except => { :no_release => true } do 
      run "mkdir -p #{shared_path}/log/apache2/"
    end

    desc "_: (useful) Enables web and runs deploy:cleanup"
    task :cleanup_deploy, :roles => :app, :except => { :no_release => true } do
      web.enable
      cleanup
    end

    desc "_: (useful) Restarts app and enables web"
    task :start, :roles => :app, :except => { :no_release => true } do
      restart
      web.enable
    end

    desc "_: (useful) Disables web"
    task :stop, :roles => :app, :except => { :no_release => true } do
      web.disable
    end

    desc "_: (useful) touches tmp/restart.txt"
    task :restart, :roles => :app, :except => { :no_release => true } do
      run "touch #{current_path}/tmp/restart.txt"
    end

  end

end
