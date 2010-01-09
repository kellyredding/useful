unless Capistrano::Configuration.respond_to?(:instance)
  abort "useful/cap_tasks requires Capistrano 2"
end

Capistrano::Configuration.instance.load do

  namespace :deploy do

    # These tasks override the default cap migration tasks
    # => allows for running your migrations on the primary app server only
  
    desc "_: (useful) Stop, update, migrate, start"
    task :migrations, :roles => :app do
      stop
      update
      migrate
      start
    end

    # Copied from http://github.com/jamis/capistrano/blob/df0935c4c135207582da343aacdd4cf080fcfed0/lib/capistrano/recipes/deploy.rb
    # => changed :roles => :db to :roles => :app so that migrations will run on the primary app server only
    desc "_: (useful) port of default cap task to only run on primary app server"
    task :migrate, :roles => :app, :only => { :primary => true } do
      rake = fetch(:rake, "rake")
      rails_env = fetch(:rails_env, "production")
      migrate_env = fetch(:migrate_env, "")
      migrate_target = fetch(:migrate_target, :latest)

      directory = case migrate_target.to_sym
        when :current then current_path
        when :latest  then current_release
        else raise ArgumentError, "unknown migration target #{migrate_target.inspect}"
        end

      run "cd #{directory}; #{rake} RAILS_ENV=#{rails_env} #{migrate_env} db:migrate", :pty => false
    end

  end

end