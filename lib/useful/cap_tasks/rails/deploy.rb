Capistrano::Configuration.instance.load do
  namespace :gems do
  
    desc "Update code, run rails 'rake gems:install'"
    task :install, :roles => :app do
      rake = fetch(:rake, "rake")
      rails_env = fetch(:rails_env, "production")

      deploy.update_code
      run "cd #{current_release}; #{rake} RAILS_ENV=#{rails_env} gems:install", :pty => false
    end
  
  end  
end
