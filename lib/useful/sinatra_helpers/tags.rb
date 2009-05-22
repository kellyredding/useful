require 'sinatra/base'

module Sinatra
  module SinatraHelpers
    module Tags
      
      # helper to emulate action view's 'link_to'
      # => inspired from vanntastic-sinatra-gen gem, http://github.com/vanntastic/sinatra-gen/tree/master
      # EX : link_to "google", "http://google.com"
      # => <a href="http://google.com">google</a>
      def link_to(content,href,options={})
        options.update :href => href
        tag(:a, options) { content }
      end

      # helper to emulate 'image_tag'
      # => inspired from vanntastic-sinatra-gen gem, http://github.com/vanntastic/sinatra-gen/tree/master
      # helper for image_tags
      # EX : image_tag 'logo.jpg'
      #  => <img src="images/logo.jpg" />
      def image_tag(src,options={})
        options[:src] = ['/'].include?(src.first) ? src : "/images/#{src}"
        tag(:img, options)
      end

      def clear_tag(options={})
        options[:tag] ||= :div
        options[:style] ||= ''
        options[:style] = "clear: both;#{options[:style]}"
        tag(options.delete(:tag), options) { '' }
      end

      include Rack::Utils
      alias_method :h, :escape_html

      # helper to emulate 'stylesheet_link_tag'
      # => inspired from vanntastic-sinatra-gen gem, http://github.com/vanntastic/sinatra-gen/tree/master
      # EX : stylesheet_link_tag 'default'
      #  => <link rel="stylesheet" href="/stylesheets/default.css" type="text/css" media="all" title="no title" charset="utf-8">
      def stylesheet_link_tag(srcs,options={})
        options[:media] ||=  "screen"
        options[:type] ||= "text/css"
        options[:rel] ||= "stylesheet"
        srcs.to_a.collect do |src|
          options[:href] = "/stylesheets/#{src}.css#{"?#{Time.now.to_i}" if Sinatra::Application.environment.to_s == 'development'}"
          tag(:link, options)
        end.join("\n")
      end

      # helper to emulate 'javascript_include_tag'
      # => inspired from vanntastic-sinatra-gen gem, http://github.com/vanntastic/sinatra-gen/tree/master
      # EX : javascript_include_tag 'app'
      #  => <script src="/js/app.js" type="text/javascript" />  
      # EX : javascript_include_tag ['app', 'jquery']
      #  => <script src="/js/app.js" type="text/javascript" />
      #  => <script src="/js/jquery.js" type="text/javascript" />
      def javascript_include_tag(srcs,options={})
        options[:type] ||= "text/javascript"
        srcs.to_a.collect do |src|
          options[:src] = "/javascripts/#{src}.js#{"?#{Time.now.to_i}" if Sinatra::Application.environment.to_s == 'development'}"
          tag(:script, options) { '' }
        end.join("\n")
      end

      # helper to emulate 'javascript_tag'
      def javascript_tag(options={})
        options[:type] ||= "text/javascript"
        tag(:script, options) { yield }
      end

      # emulator for 'tag'
      # => inspired from vanntastic-sinatra-gen gem, http://github.com/vanntastic/sinatra-gen/tree/master
      # EX : tag :h1, "shizam", :title => "shizam"
      # => <h1 title="shizam">shizam</h1>
      def tag(name,options={})
        "<#{name.to_s} #{hash_to_html_attrs(options)} #{block_given? ? ">#{yield}</#{name}" : "/"}>"
      end
      
      private
      
      def hash_to_html_attrs(a_hash)
        a_hash.collect{|key, val| "#{key}=\"#{val}\""}.join(' ')
      end

    end
  end
  
  Sinatra::Application.helpers Sinatra::SinatraHelpers::Tags
end
