unless Capistrano::Configuration.respond_to?(:instance)
  abort "useful/cap_tasks requires Capistrano 2"
end

Capistrano::Configuration.instance.load do

  namespace :deploy do

    desc "_: (#{application}) no migrating needed, this one does nothing..."
    task :migrate, :roles => :app, :only => { :primary => true } do
    end
  
  end

end