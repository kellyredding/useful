module Useful
  module RubyExtensionsFromRails
    module Object
      
      def blank?
        self.nil? || (self.respond_to?(:empty?) ? self.empty? : false)
      end

      # Returns +value+ after yielding +value+ to the block. This simplifies the
      # process of constructing an object, performing work on the object, and then
      # returning the object from a method. It is a Ruby-ized realization of the K
      # combinator, courtesy of Mikael Brockman.
      #
      # ==== Examples
      #
      #  # Without returning
      #  def foo
      #    values = []
      #    values << "bar"
      #    values << "baz"
      #    return values
      #  end
      #
      #  foo # => ['bar', 'baz']
      #
      #  # returning with a local variable
      #  def foo
      #    returning values = [] do
      #      values << 'bar'
      #      values << 'baz'
      #    end
      #  end
      #
      #  foo # => ['bar', 'baz']
      #  
      #  # returning with a block argument
      #  def foo
      #    returning [] do |values|
      #      values << 'bar'
      #      values << 'baz'
      #    end
      #  end
      #  
      #  foo # => ['bar', 'baz']
      def returning(value)
        yield(value)
        value
      end

      # Yields <code>x</code> to the block, and then returns <code>x</code>.
      # The primary purpose of this method is to "tap into" a method chain,
      # in order to perform operations on intermediate results within the chain.
      #
      #   (1..10).tap { |x| puts "original: #{x.inspect}" }.to_a.
      #     tap    { |x| puts "array: #{x.inspect}" }.
      #     select { |x| x%2 == 0 }.
      #     tap    { |x| puts "evens: #{x.inspect}" }.
      #     map    { |x| x*x }.
      #     tap    { |x| puts "squares: #{x.inspect}" }
      def tap
        yield self
        self
      end unless ::Object.respond_to?(:tap)

      # A duck-type assistant method. For example, Active Support extends Date
      # to define an acts_like_date? method, and extends Time to define
      # acts_like_time?. As a result, we can do "x.acts_like?(:time)" and
      # "x.acts_like?(:date)" to do duck-type-safe comparisons, since classes that
      # we want to act like Time simply need to define an acts_like_time? method.
      def acts_like?(duck)
        respond_to? "acts_like_#{duck}?"
      end
    end
  end
end

class Object
  include Useful::RubyExtensionsFromRails::Object
end
