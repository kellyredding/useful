require File.join(File.dirname(__FILE__), 'duration')

module Useful
  module RubyExtensionsFromRails
    module Numeric

      def seconds
        Useful::RubyExtensionsFromRails::Duration.new(self, [[:seconds, self]])
      end
      alias :second :seconds

      def minutes
        Useful::RubyExtensionsFromRails::Duration.new(self * 60, [[:seconds, self * 60]])
      end
      alias :minute :minutes  

      def hours
        Useful::RubyExtensionsFromRails::Duration.new(self * 3600, [[:seconds, self * 3600]])
      end
      alias :hour :hours

      def days
        Useful::RubyExtensionsFromRails::Duration.new(self * 24.hours, [[:days, self]])
      end
      alias :day :days

      def weeks
        Useful::RubyExtensionsFromRails::Duration.new(self * 7.days, [[:days, self * 7]])
      end
      alias :week :weeks

      def fortnights
        Useful::RubyExtensionsFromRails::Duration.new(self * 2.weeks, [[:days, self * 14]])
      end
      alias :fortnight :fortnights

      # Reads best without arguments:  10.minutes.ago
      def ago(time = ::Time.now)
        time - self
      end

      # Reads best with argument:  10.minutes.until(time)
      alias :until :ago

      # Reads best with argument:  10.minutes.since(time)
      def since(time = ::Time.now)
        time + self
      end

      # Reads best without arguments:  10.minutes.from_now
      alias :from_now :since

    end
  end
end


class Numeric
  include Useful::RubyExtensionsFromRails::Numeric
end
