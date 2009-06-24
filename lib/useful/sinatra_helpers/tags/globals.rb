require 'sinatra/base'
require File.join(File.dirname(__FILE__), 'helpers.rb')

module Useful
  module SinatraHelpers
    module Tags
      module Globals
        
        include Useful::SinatraHelpers::Tags::Helpers
        
        def input_tag(name, type, value, options={}, &block)
          options[:tag] ||= :input
          options[:id] ||= sinatra_tag_helper_safe_id(name)
          options[:value] = value unless value.nil?
          options.update :name => name, :type => type
          tag(options.delete(:tag), options, &block)
        end

        def clear_tag(options={})
          options[:tag] ||= :div
          options[:style] ||= ''
          options[:style] = "clear: both;#{options[:style]}"
          tag(options.delete(:tag), options) { '' }
        end

        include Rack::Utils
        alias_method :h, :escape_html

        # emulator for 'tag'
        # EX : tag :h1, "shizam", :title => "shizam"
        # => <h1 title="shizam">shizam</h1>
        def tag(name,options={})
          "<#{name.to_s} #{sinatra_tag_helper_hash_to_html_attrs(options)} #{block_given? ? ">#{yield}</#{name}" : "/"}>"
        end
        
      end      
    end
  end
end

Sinatra::Application.helpers Useful::SinatraHelpers::Tags::Globals

