require 'useful/erb_helpers/common'
require 'useful/erb_helpers/tags'

module Useful; end
module Useful::ErbHelpers; end

module Useful::ErbHelpers::Links
  
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
  # EX : mail_link_to "test@example.com"
  # => <a href="mailto:test@example.com">test@example.com</a>
  # EX : mail_link_to "Test", "test@example.com"
  # => <a href="mailto:test@example.com">Test</a>
  # EX : mail_link_to "Test", "test@example.com", :class => "awesome"
  # => <a href="mailto:test@example.com" class="awesome">Kelly</a>
  def mail_link_to(*args)
    content, email, options = link_content_href_opts(args)
    link_to content, "mailto: #{email}", options
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
  def image_tag(src,options={})
    options[:src] = ['/'].include?(src[0..0]) ? src : "/images/#{src}"
    tag(:img, options)
  end

  # helper to emulate activesupport's 'stylesheet_link_tag'
  # EX : stylesheet_link_tag 'default'
  #  => <link rel="stylesheet" type="text/css" media="all" href="/stylesheets/default.css">
  # EX : stylesheet_link_tag 'default', :environment => 'development'
  #  => <link rel="stylesheet" type="text/css" media="screen" href="/stylesheets/default.css?12345678">
  # EX : stylesheet_link_tag 'default', :media => 'screen'
  #  => <link rel="stylesheet" type="text/css" media="screen" href="/stylesheets/default.css">
  # EX : stylesheet_link_tag 'default', 'test, :media => 'screen'
  #  => <link rel="stylesheet" type="text/css" media="screen" href="/stylesheets/default.css">
  #  => <link rel="stylesheet" type="text/css" media="screen" href="/stylesheets/test.css">
  # EX : stylesheet_link_tag ['default', 'test], :media => 'screen'
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
    Array(srcs).collect do |src|
      #TODO: write sinatra helper to auto set env with Sinatra::Application.environment.to_s
      options[:href] = build_src_href(src, :default_path => "stylesheets", :extension => ".css", :environment => options.delete(:environment))
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
    Array(srcs).collect do |src|
      #TODO: write sinatra helper to auto set env with Sinatra::Application.environment.to_s
      options[:src] = build_src_href(src, :default_path => "javascripts", :extension => ".js", :environment => options.delete(:environment))
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
      [args[0], args[0], (args[1] || {})]
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
    href = ""
    href += ['/'].include?(src[0..0]) ? src : "/#{options[:default_path]}/#{src}"
    href += options[:extension] unless src.include?(options[:extension])
    href += "?#{Time.now.to_i}" if options[:environment].to_s == 'development'
    href
  end

end
  
