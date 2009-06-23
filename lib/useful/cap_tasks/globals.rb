def run_with_password(cmd, options={})
  prompt = options.delete(:prompt) || 'Password: '
  password = options.delete(:password)
  log (options.delete(:confirmation) || "Running: '#{cmd}'")
  password ||= Capistrano::CLI.password_prompt(prompt)
  run cmd, options do |ch, stream, out|
    ch.send_data(password+"\n")
  end
  password
end

def run_locally(cmd)
  log cmd
  resp = `#{cmd}` rescue nil
  log resp
end

def log(msg, opts = {})
  if opts[:force]
    puts " ** #{msg}"
  else
    logger.info(msg)
  end
end

def total_time_in_values(total_time)
  total_time = total_time.round
  values = Hash.new
  values[:minutes] = (total_time) / (60)
  values[:seconds] = total_time - values[:minutes]*60
  values
end


