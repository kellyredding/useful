Capistrano::Configuration.instance.load do
  namespace :gemsconfig do

    desc "Update code, run 'rake gemsconfig:install'"
    task :install, :roles => fetch(:install_roles, :app) do
      deploy.update_code
      run_with_password("sudo #{fetch(:rake, "rake")} -f #{current_release}/Rakefile #{"RAILS_ENV=#{rails_env}" if rails_env} #{fetch(:gemsconfig, "gemsconfig")}:install", {
        :prompt => "Enter sudo pw: ",
        :pty => false
      })
    end

  end
end
