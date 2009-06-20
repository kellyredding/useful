module Useful
  module Version
    
    MAJOR = 0
    MINOR = 1
    TINY  = 8
    FIX   = 1
    
    def self.to_s # :nodoc:
      [MAJOR, MINOR, TINY, FIX].join('.')
    end
    
  end
end
