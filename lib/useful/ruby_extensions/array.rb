module Useful
  module RubyExtensions
    module Array
      
      module ClassMethods; end
      def self.included(klass)
        klass.extend(ClassMethods) if klass.kind_of?(Class)
      end

      module ClassMethods

        # adds the contents of a2 to a1, removing duplicates
        def merge(a1,a2)
          a2.each{|item| a1 << item unless a1.include?(item)}
          a1
        end
        
      end

      # returns a new array, containing the contents of an_a with the contents of this array, removing duplicates
      def merge(an_a)
        self.class.merge(self.clone, an_a)
      end
      # adds the contents of an_a to this array, removing duplicates (inline version of #merge)
      def merge!(an_a)
        self.class.merge(self, an_a)
      end

      # split into an array of sized-arrays
      def groups(size=1)
        return [] if size <= 0
        n,r = self.size.divmod(size)
        grps = (0..(n-1)).collect{|i| self[i*size,size]}
        r > 0 ? grps << self[-r,r] : grps
      end
      alias / groups
      alias chunks groups

    end
  end
end

class Array
  include Useful::RubyExtensions::Array
end
