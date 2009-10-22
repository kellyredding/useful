require 'erb'

require 'useful/erb_helpers/common'
require 'useful/ruby_extensions/hash' unless ::Hash.new.respond_to?(:to_html_attrs)

module Useful; end
module Useful::ErbHelpers; end

module Useful::ErbHelpers::Tags
  
  include Useful::ErbHelpers::Common
  
  def input_tag(type, name, value, options={}, &block)
    options[:tag] ||= :input
    options[:type] = type unless type.nil?
    unless name.nil?
      options[:name] = name 
      options[:id] ||= erb_helper_common_safe_id(name)
    end
    options[:value] = value unless value.nil?
    tag(options.delete(:tag), options, &block)
  end

  def clear_tag(options={})
    options[:tag] ||= :div
    options[:style] ||= ''
    options[:style] = "clear: both;#{options[:style]}"
    tag(options.delete(:tag), options) { '' }
  end

  # helpers to escape tag text content
  if defined?(::Rack::Utils)
    include ::Rack::Utils
    alias_method :h, :escape_html

    # escape tag text content and format for text-like display
    def h_text(text, opts={})
      h(text.to_s).
        gsub(/\r\n?/, "\n").  # \r\n and \r -> \n
        split("\n").collect do |line|
          line.nil? ? '': line.sub(/(\s+)?\S*/) {|lead| lead.gsub(/\s/,'&nbsp;')}
        end.join("\n"). # change any leading white spaces on a line to '&nbsp;'
        gsub(/\n/,'\1<br />') # newlines -> br added
    end
  end

  # emulator for rails' 'content_tag'
  # EX : tag(:h1, :title => "shizam") { "shizam" }
  # => <h1 title="shizam">shizam</h1>
  def tag(name, options={})
    "<#{name.to_s} #{options.to_html_attrs} #{block_given? ? ">#{yield}</#{name}" : "/"}>"
  end
  
end      

