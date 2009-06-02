module Useful
  module RubyExtensions
    module String
      
      module ClassMethods; end
      def self.included(klass)
        klass.extend(ClassMethods) if klass.kind_of?(Class)
      end

      module ClassMethods

        # adds the contents of a2 to a1, removing duplicates
        def hsub(string, hash)
          hash.each {|k,v| string.gsub!(":#{k}",v.to_s)}
          string
        end
        
      end

      # returns a new string, with hash values sub'd in where hash keys exist in original string
      def hsub(hash)
        self.class.hsub(self.clone, hash)
      end
      # substitutes the keys in hash that exist in the string, with values of hash
      def hsub!(hash)
        self.class.hsub(self, hash)
      end

      def match?(pattern)
        !self.match(pattern).nil?
      end

      def show_regexp(re)
        if self =~ re
          "#{$`}<<#{$&}>>#{$'}"
        else
          "no match"
        end
      end

    end
  end
end

class String
  include Useful::RubyExtensions::String
end
