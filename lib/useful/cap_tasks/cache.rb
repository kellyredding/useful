Capistrano::Configuration.instance.load do
  namespace :cache do
  
    desc "Update code, run 'rake gems:install'"
    task :install, :roles => :app do
      deploy.update_code
      run "cd #{current_release}; sudo #{fetch(:rake, "rake")} #{"RAILS_ENV=#{rails_env}" if defined?(rails_env)} gems:install"
    end
  
  end  
end
