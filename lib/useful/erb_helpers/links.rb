require 'useful/erb_helpers/common'
require 'useful/erb_helpers/tags'
require 'useful/ruby_extensions/string' unless ::String.new.respond_to?('cgi_escape')
require 'useful/ruby_extensions/hash' unless ::Hash.new.respond_to?('to_http_query_str')

module Useful; end
module Useful::ErbHelpers; end

module Useful::ErbHelpers::Links
  
  ABSOLUTE_LINK_PATH = /\Ahttp[s]*:\/\//
  
  include Useful::ErbHelpers::Common
  
  # helper to emulate action view's 'link_to'
  # EX : link_to "http://google.com"
  # => <a href="http://google.com">http://google.com</a>
  # EX : link_to "google", "http://google.com"
  # => <a href="http://google.com">google</a>
  # EX : link_to "google", "http://google.com", :class => "awesome"
  # => <a href="http://google.com" class="awesome">google</a>
  # EX : link_to "http://google.com", :popup => true
  # => <a href="http://google.com" onclick="javascript: window.open(this.href); return false;">http://google.com</a>
  # EX : link_to "http://google.com", :popup => ['new_window_name', 'height=300,width=600']
  # => <a href="http://google.com" onclick="javascript: window.open(this.href,'new_window_name','height=300,width=600'); return false;">http://google.com</a>
  # EX : link_to "http://google.com", :confirm => "Are you sure?"
  # => <a href="http://google.com" onclick="javascript: return confirm('Are you sure?');">http://google.com</a>
  # EX : link_to "http://google.com", :confirm => "Are you sure?", :popup => true
  # => <a href="http://google.com" onclick="javascript: if (confirm('Are you sure?')) { window.open(this.href); }; return false;">http://google.com</a>
  def link_to(*args)
    content, href, options = link_content_href_opts(args)
    options.update :href => href
    erb_helper_convert_options_to_javascript!(options)
    tag(:a, options) { content }
  end
  
  # helper for generating a mailto:
  # EX: mail_to "me@domain.com"
  #   # => <a href="mailto:me@domain.com">me@domain.com</a>
  # EX: mail_to "me@domain.com", nil, :replace_at => "_at_", :replace_dot => "_dot_", :class => "email"
  #   # => <a href="mailto:me@domain.com" class="email">me_at_domain_dot_com</a>
  # EX: mail_to "me@domain.com", nil, :replace_at => " [at]", :replace_dot => " [dot] ", :disabled => true
  #   # => me [at] domain [dot] com
  # EX: mail_to "me@domain.com", "My email", :cc => "ccaddress@domain.com", :subject => "This is an example email"
  #   # => <a href="mailto:me@domain.com?cc=ccaddress@domain.com&subject=This%20is%20an%20example%20email">My email</a>
  def mail_to(*args)
    content, email, options = link_content_href_opts(args)
    email_args = [:cc, :bcc, :subject, :body].inject({}) do |args, arg|
      args[arg] = options.delete(arg) if options.has_key?(arg)
      args
    end
    content.gsub!(/@/, options.delete(:replace_at)) if options.has_key?(:replace_at)
    content.gsub!(/\./, options.delete(:replace_dot)) if options.has_key?(:replace_dot)
    options.delete(:disabled) ? content : link_to(content, "mailto: #{email}#{email_args.to_http_query_str}", options)
  end

  def link_to_function(content, function, opts={})
    opts ||= {}
    opts[:href] ||= 'javascript: void(0);'
    opts[:onclick] = "javascript: #{function}; return false;"
    link_to content, opts[:href], opts
  end

  # helper to emulate 'image_tag'
  # EX : image_tag 'logo.jpg'
  #  => <img src="/images/logo.jpg" />
  # EX : image_tag '/better/logo.jpg'
  #  => <img src="/better/logo.jpg" />
  def image_tag(source,options={})
    options[:src] = if source =~ ABSOLUTE_LINK_PATH
      source
    else
      ['/'].include?(source[0..0]) ? source : "/images/#{source}"
    end
    tag(:img, options)
  end

  # helper to emulate activesupport's 'stylesheet_link_tag'
  # EX : stylesheet_link_tag 'default'
  #  => <link rel="stylesheet" type="text/css" media="all" href="/stylesheets/default.css">
  # EX : stylesheet_link_tag 'default', :timestamp => true
  #  => <link rel="stylesheet" type="text/css" media="screen" href="/stylesheets/default.css?12345678">
  # EX : stylesheet_link_tag 'default', :media => 'screen'
  #  => <link rel="stylesheet" type="text/css" media="screen" href="/stylesheets/default.css">
  # EX : stylesheet_link_tag 'default', 'test', :media => 'screen'
  #  => <link rel="stylesheet" type="text/css" media="screen" href="/stylesheets/default.css">
  #  => <link rel="stylesheet" type="text/css" media="screen" href="/stylesheets/test.css">
  # EX : stylesheet_link_tag ['default', 'test'], :media => 'screen'
  #  => <link rel="stylesheet" type="text/css" media="screen" href="/stylesheets/default.css">
  #  => <link rel="stylesheet" type="text/css" media="screen" href="/stylesheets/test.css">
  # EX : stylesheet_link_tag 'default', '/other_sheets/other', '/other_sheets/another.css'
  #  => <link rel="stylesheet" type="text/css" media="screen" href="/stylesheets/default.css">
  #  => <link rel="stylesheet" type="text/css" media="screen" href="/other_sheets/other.css">
  #  => <link rel="stylesheet" type="text/css" media="screen" href="/other_sheets/another.css">
  def stylesheet_link_tag(*args)
    srcs, options = handle_srcs_options(args)
    options[:rel] ||= "stylesheet"
    options[:type] ||= "text/css"
    options[:media] ||=  "all"
    timestamp = options.delete(:timestamp)
    Array(srcs).collect do |src|
      #TODO: write sinatra helper to auto set env with Sinatra::Application.environment.to_s
      options[:href] = build_src_href(src, :default_path => "stylesheets", :extension => ".css", :timestamp => timestamp)
      tag(:link, options)
    end.join("\n")
  end

  # helper to emulate 'javascript_tag'
  def javascript_tag(options={})
    options[:type] ||= "text/javascript"
    tag(:script, options) { yield }
  end
  
  # helper to emulate 'javascript_include_tag'
  # EX : javascript_include_tag 'app'
  #  => <script src="/js/app.js" type="text/javascript" />  
  # EX : javascript_include_tag ['app', 'jquery']
  #  => <script src="/js/app.js" type="text/javascript" />
  #  => <script src="/js/jquery.js" type="text/javascript" />
  def javascript_include_tag(*args)
    srcs, options = handle_srcs_options(args)
    options[:type] ||= "text/javascript"
    timestamp = options.delete(:timestamp)
    Array(srcs).collect do |src|
      #TODO: write sinatra helper to auto set env with Sinatra::Application.environment.to_s
      options[:src] = build_src_href(src, :default_path => "javascripts", :extension => ".js", :timestamp => timestamp)
      tag(:script, options) { '' }
    end.join("\n")
  end

  def self.included(receiver)
    receiver.send :include, Useful::ErbHelpers::Tags
  end
  
  private
  
  def link_content_href_opts(args)
    if args[1] && !args[1].kind_of?(::Hash)
      [args[0], args[1], (args[2] || {})]
    else
      [args[0], args[0].dup, (args[1] || {})]
    end
  end
  
  def handle_srcs_options(args)
    the_args = args.flatten
    if the_args.last && the_args.last.kind_of?(::Hash)
      [the_args[0..-2], the_args.last]
    else
      [the_args, {}]
    end
  end
  
  def build_src_href(src, options)
    options[:timestamp] = Time.now.to_i if options[:timestamp] == true
    src = src.to_s
    if src =~ ABSOLUTE_LINK_PATH
      src
    else
      href = ""
      href += ['/'].include?(src[0..0]) ? src : "/#{options[:default_path]}/#{src}"
      href += options[:extension] unless src.include?(options[:extension])
      href += "?#{options[:timestamp]}" if options[:timestamp] && !src.include?('?')
      href
    end
  end

end
  
