unless Capistrano::Configuration.respond_to?(:instance)
  abort "useful/cap_tasks requires Capistrano 2"
end

Capistrano::Configuration.instance.load do

  set :down_html, "down"

  namespace :deploy do

    namespace :web do
      desc "_: (useful) Remove the down html page."
      task :enable, :roles => :app, :except => { :no_release => true } do
        run "rm #{current_path}/public/#{down_html}.html"
      end

      desc "_: (useful) Put up the down html page"
      task :disable, :roles => :app, :except => { :no_release => true } do
        run "cp #{shared_path}/#{down_html}.html #{current_path}/public/#{down_html}.html"
      end
    end

  end

end
