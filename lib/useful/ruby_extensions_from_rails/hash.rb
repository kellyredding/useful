module Useful; end
module Useful::RubyExtensionsFromRails; end

module Useful::RubyExtensionsFromRails::Hash

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
    
    # inspired by ActiveSupport::CoreExtensions::Hash::Keys (http://api.rubyonrails.org/)
    def symbolize_keys(hash)
      hash.keys.each{ |key| hash[(key.to_sym rescue key)] ||= hash.delete(key) }
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

end

class Hash
  include Useful::RubyExtensionsFromRails::Hash
end
