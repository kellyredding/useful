require 'sinatra/base'

module Sinatra
  module SinatraHelpers
    module Tags
      module Globals

        def clear_tag(options={})
          options[:tag] ||= :div
          options[:style] ||= ''
          options[:style] = "clear: both;#{options[:style]}"
          tag(options.delete(:tag), options) { '' }
        end

        include Rack::Utils
        alias_method :h, :escape_html

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
  end
  
  Sinatra::Application.helpers Sinatra::SinatraHelpers::Tags::Globals
end
