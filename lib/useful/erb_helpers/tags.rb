require 'useful/ruby_extensions/object' unless ::Object.new.respond_to?('blank?')
require 'useful/ruby_extensions/hash' unless ::Hash.new.respond_to?('to_html_attrs')

module Useful; end
module Useful::ErbHelpers; end

module Useful::ErbHelpers::Tags
  
  def clear_tag(options={})
    options[:tag] ||= :div
    options[:style] ||= ''
    options[:style] = "clear:both;#{" #{options[:style]}" unless options[:style].blank?}"
    tag(options.delete(:tag), options) { '' }
  end

  # helpers to escape text for html
  if defined?(::Rack::Utils)
    include ::Rack::Utils
    alias_method :h, :escape_html
  end
  if defined?('h')
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
    "<#{name.to_s}#{" #{options.to_html_attrs}" unless options.empty?}#{block_given? ? ">#{yield}</#{name}" : " /"}>"
  end
  
end      

