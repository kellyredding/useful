require 'cgi'

module Useful
  module RubyExtensions
    module Hash

      # Determines if a value exists for the provided key(s).  Allows searching in nested hashes
      def check_value?(*keys)
        val = self[keys.first] || self[keys.first.to_s]
        val = self[keys.first.to_s.intern] unless val || keys.first.kind_of?(Symbol) 
        return val.check_value?(*keys[1..-1]) if val.kind_of?(Hash) && keys.length > 1
        return true if val && !val.empty?
        false
      end

      # takes any empty values and makes them nil inline
      def nillify!
        self.each { |key,value| self[key] = nil if !value.nil? && value.to_s.empty? }
      end

      # Returns string formatted for HTTP URL encoded name-value pairs.
      # For example,
      #  {:id => 'thomas_hardy'}.to_http_str 
      #  # => "id=thomas_hardy"
      #  {:id => 23423, :since => Time.now}.to_http_str
      #  # => "since=Thu,%2021%20Jun%202007%2012:10:05%20-0500&id=23423"
      def to_http_str
        self.empty? ? '' : self.collect{|key, val| "#{key.to_s}=#{CGI.escape(val.to_s)}"}.join('&')
      end

      def to_html_attrs
        self.empty? ? '' : self.collect{|key, val| "#{key}=\"#{val}\""}.join(' ')
      end

    end
  end
end

class Hash
  include Useful::RubyExtensions::Hash
end