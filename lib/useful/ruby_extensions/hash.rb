require 'cgi'

module Useful
  module RubyExtensions
    module Hash

      module ClassMethods; end
      def self.included(klass)
        klass.extend(ClassMethods) if klass.kind_of?(Class)
      end

      module ClassMethods

        # inspired by ActiveSupport::CoreExtensions::Hash::Keys (http://api.rubyonrails.org/)
        def stringify_keys(hash)
          hash.keys.each{ |key| hash[(key.to_s rescue key)] ||= hash.delete(key) }
          hash
        end
        
        # inspired by from ActiveSupport::CoreExtensions::Hash::Keys (http://api.rubyonrails.org/)
        def symbolize_keys(hash)
          hash.keys.each{ |key| hash[(key.to_sym rescue key)] ||= hash.delete(key) }
          hash
        end
        
        def only(hash, *keys)
          hash.delete_if{ |k,v| !keys.flatten.include?(k) }
          hash
        end
        
        def except(hash, *keys)
          hash.delete_if{ |k,v| keys.flatten.include?(k) }
          hash
        end
        
      end

      # Return a new hash with all keys converted to strings.
      def stringify_keys
        self.class.stringify_keys(self.clone)
      end
      # Destructively convert all keys to strings. 
      def stringify_keys!
        self.class.stringify_keys(self)
      end

      # Return a new hash with all keys converted to strings.
      def symbolize_keys
        self.class.symbolize_keys(self.clone)
      end
      # Destructively convert all keys to strings. 
      def symbolize_keys!
        self.class.symbolize_keys(self)
      end

      # Return a new hash with only keys in *keys
      def only(*keys)
        self.class.only(self.clone, keys)
      end
      # Destructively remove all keys not in *keys
      def only!(*keys)
        self.class.only(self, keys)
      end

      # Return a new hash with only keys not in *keys
      def except(*keys)
        self.class.except(self.clone, keys)
      end
      # Destructively remove all keys in *keys
      def except!(*keys)
        self.class.except(self, keys)
      end

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
      def to_http_query_str(opts = {})
        opts[:prepend] ||= '?'
        opts[:append] ||= ''
        self.empty? ? '' : "#{opts[:prepend]}#{self.collect{|key, val| "#{key.to_s}=#{CGI.escape(val.to_s)}"}.join('&')}#{opts[:append]}"
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
