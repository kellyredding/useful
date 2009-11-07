# Note: these helpers are designed to be actionpack safe
# => these helpers are included in the useful/rails_extensions/erb
# => don't put any actionpack helpers in this module

require 'useful/erb_helpers/common'
require 'useful/ruby_extensions/object' unless ::Object.new.respond_to?('blank?')
require 'useful/ruby_extensions/hash' unless ::Hash.new.respond_to?('to_html_attrs')

module Useful; end
module Useful::ErbHelpers; end

module Useful::ErbHelpers::Tags
  
  include Useful::ErbHelpers::Common
  
  def clear_tag(options={})
    options[:tag] ||= :div
    options[:style] ||= ''
    options[:style] = "clear:both;#{" #{options[:style]}" unless options[:style].blank?}"
    tag(options.delete(:tag), options) { '' }
  end

  # helpers to escape text for html
  if defined?(::Rack::Utils)
    include ::Rack::Utils
    alias_method(:h, :escape_html)
  end
  if defined?(:h)
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

  def input_tag(type, name, value=nil, options={}, &block)
    options[:tag] ||= :input
    options[:type] = type unless type.nil?
    unless name.nil?
      options[:name] = name 
      options[:id] ||= erb_helper_common_safe_id(name)
    end
    options[:value] = value unless value.nil?
    options[:disabled] = OPTIONS[:disabled] if options[:disabled]
    if block_given?
      tag(options.delete(:tag), options) { erb_helper_common_capture(&block) }
    else
      tag(options.delete(:tag), options)
    end
  end

  # emulator for rails' 'content_tag'
  # EX : tag(:h1, :title => "shizam") { "shizam" }
  # => <h1 title="shizam">shizam</h1>
  def tag(name, options={})
    "<#{name.to_s}#{" #{options.to_html_attrs}" unless options.empty?}#{block_given? ? ">#{yield}</#{name}" : " /"}>"
  end
  
end      

