module Useful; end
module Useful::RubyExtensions; end

module Useful::RubyExtensions::String

  module ClassMethods

    # adds the contents of a2 to a1, removing duplicates
    def hsub(string, hash)
      hash.each {|k,v| string.gsub!(":#{k}",v.to_s)}
      string
    end
    
    def match?(string, pattern)
      !string.match(pattern).nil?
    end
    
    def show_regexp(string, re)
      if string =~ re
        "#{$`}<<#{$&}>>#{$'}"
      else
        "no match"
      end
    end

  end
  
  module InstanceMethods

    # returns a new string, with hash values sub'd in where hash keys exist in original string
    def hsub(hash)
      self.class.hsub(self.clone, hash)
    end
    # substitutes the keys in hash that exist in the string, with values of hash
    def hsub!(hash)
      self.class.hsub(self, hash)
    end

    def match?(pattern)
      self.class.match?(self, pattern)
    end

    def show_regexp(re)
      self.class.show_regexp(self, re)
    end

    def to_boolean
      self =~ /^(true|1)$/i ? true : false
    end

  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end

end

class String
  include Useful::RubyExtensions::String
end
