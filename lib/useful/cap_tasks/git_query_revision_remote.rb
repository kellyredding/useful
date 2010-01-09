unless Capistrano::Configuration.respond_to?(:instance)
  abort "useful/cap_tasks requires Capistrano 2"
end

Capistrano::Configuration.instance.load do

  set :real_revision, "blahblahblahnotthis"

  namespace :deploy do
  
    before  'deploy:update_code', 'deploy:set_git_branch'
    before  'deploy:update_code', 'deploy:lookup_git_revision'

    desc '_: (useful) Set branch to current git branch'
    task :set_git_branch, :roles => :app, :only => { :primary => true } do
      # Set the branch name to current git HEAD if this stage is configured that way
      if branch == :current_git_branch
        set :branch, run_locally("git symbolic-ref HEAD 2>/dev/null").split('/').last.strip
      end
    end

    desc '_: (useful) Get git revision from server to avoid typing password'
    task :lookup_git_revision, :roles => :app, :only => { :primary => true } do
      # hack to remotely lookup the revision sending the config'd scm_password
      # => prevents having to enter it locally
      set :real_revision, source.local.query_revision(revision) { |cmd|
        with_env("LC_ALL", "C") {
          result = nil
          run cmd do |ch, stream, out|
            ch.send_data(scm_password)
            ch.send_data("\n")
            result = out
          end
          result
        }
      }
    end

  end

end
