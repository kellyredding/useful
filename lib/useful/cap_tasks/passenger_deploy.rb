unless Capistrano::Configuration.respond_to?(:instance)
  abort "useful/cap_tasks requires Capistrano 2"
end

Capistrano::Configuration.instance.load do

  namespace :deploy do

    task :after_deploy, :except => { :no_release => true } do
      web.enable
      cleanup
    end
  
    desc "_: (#{application}) Start app from cold state."
    task :start, :roles => :app, :except => { :no_release => true } do
      restart
      web.enable
    end

    desc "_: (#{application}) Stop app and put in cold state."
    task :stop, :roles => :app, :except => { :no_release => true } do
      web.disable
    end

    desc "_: (#{application}) Restart app from hot state."
    task :restart, :roles => :app, :except => { :no_release => true } do
      run "touch #{current_path}/tmp/restart.txt"
    end

  end

  namespace :web do
    desc "_: (#{application}) Enable app and remove down page."
    task :enable, :roles => :app, :except => { :no_release => true } do
      run "rm #{current_path}/public/#{down_html}.html"
    end

    desc "_: (#{application}) Put up down page and disable app"
    task :disable, :roles => :app, :except => { :no_release => true } do
      run "cp #{shared_path}/#{down_html}.html #{current_path}/public/#{down_html}.html"
    end
  end

end
