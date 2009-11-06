unless Capistrano::Configuration.respond_to?(:instance)
  abort "useful/cap_tasks requires Capistrano 2"
end

Capistrano::Configuration.instance.load do

  namespace :deploy do
  
    task :before_update_code, :except => { :no_release => true } do

      # Set the branch name to current git HEAD if this stage is configured that way
      set :branch, run_locally("git symbolic-ref HEAD 2>/dev/null").split('/').last.strip if branch == :current_git_branch

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
