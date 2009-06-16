require File.join(File.dirname(__FILE__), 'object') unless Object.new.respond_to?(:acts_like?)
require File.join(File.dirname(__FILE__), 'duration')

module Useful
  module RubyExtensionsFromRails
    module Date
      
      DATE_FORMATS = {
        :short        => "%e %b",
        :long         => "%B %e, %Y",
        :db           => "%Y-%m-%d",
        :number       => "%Y%m%d",
        :long_ordinal => lambda { |date| date.strftime("%B #{date.day.ordinalize}, %Y") }, # => "April 25th, 2007"
        :rfc822       => "%e %b %Y"
      }

      module ClassMethods; end
      def self.included(klass)
        klass.extend(ClassMethods) if klass.kind_of?(Class)
        
        klass.instance_eval do
          alias_method :to_default_s, :to_s
          alias_method :to_s, :to_formatted_s
          alias_method :default_inspect, :inspect
          alias_method :inspect, :readable_inspect

          # Ruby 1.9 has Date#to_time which converts to localtime only.
          remove_method :to_time if klass.instance_methods.include?(:to_time)

          # Ruby 1.9 has Date#xmlschema which converts to a string without the time component.
          remove_method :xmlschema if klass.instance_methods.include?(:xmlschema)
        end
      end

      module ClassMethods
        
        # Returns a new Date representing the date 1 day ago (i.e. yesterday's date).
        def yesterday
          ::Date.today.yesterday
        end

        # Returns a new Date representing the date 1 day after today (i.e. tomorrow's date).
        def tomorrow
          ::Date.today.tomorrow
        end

        # Returns Date.today.
        def current
          ::Date.today
        end
        
      end

      # Enable more predictable duck-typing on Date-like classes. See
      # Object#acts_like?.
      def acts_like_date?
        true
      end

      # Tells whether the Date object's date lies in the past
      def past?
        self < ::Date.current
      end

      # Tells whether the Date object's date is today
      def today?
        self.to_date == ::Date.current # we need the to_date because of DateTime
      end

      # Tells whether the Date object's date lies in the future
      def future?
        self > ::Date.current
      end

      # Provides precise Date calculations for years, months, and days.  The +options+ parameter takes a hash with
      # any of these keys: <tt>:years</tt>, <tt>:months</tt>, <tt>:weeks</tt>, <tt>:days</tt>.
      def advance(options)
        d = self
        d = d >> options.delete(:years) * 12 if options[:years]
        d = d >> options.delete(:months)     if options[:months]
        d = d +  options.delete(:weeks) * 7  if options[:weeks]
        d = d +  options.delete(:days)       if options[:days]
        d
      end

      # Returns a new Date where one or more of the elements have been changed according to the +options+ parameter.
      #
      # Examples:
      #
      #   Date.new(2007, 5, 12).change(:day => 1)                  # => Date.new(2007, 5, 1)
      #   Date.new(2007, 5, 12).change(:year => 2005, :month => 1) # => Date.new(2005, 1, 12)
      def change(options)
        ::Date.new(
          options[:year]  || self.year,
          options[:month] || self.month,
          options[:day]   || self.day
        )
      end

      # Converts Date to a Time (or DateTime if necessary) with the time portion set to the beginning of the day (0:00)
      def beginning_of_day
        to_time
      end
      alias :midnight :beginning_of_day
      alias :at_midnight :beginning_of_day
      alias :at_beginning_of_day :beginning_of_day

      # Converts Date to a Time (or DateTime if necessary) with the time portion set to the end of the day (23:59:59)
      def end_of_day
        to_time.end_of_day
      end
      alias :at_end_of_day :end_of_day

      # Returns a new Date representing the "start" of this week (i.e, Monday; DateTime objects will have time set to 0:00)
      def beginning_of_week
        days_to_monday = self.wday!=0 ? self.wday-1 : 6
        self - days_to_monday
      end
      alias :monday :beginning_of_week
      alias :at_beginning_of_week :beginning_of_week

      # Returns a new Date representing the end of this week (Sunday, DateTime objects will have time set to 23:59:59)
      def end_of_week
        days_to_sunday = self.wday!=0 ? 7-self.wday : 0
        self + days_to_sunday.days
      end
      alias :at_end_of_week :end_of_week

      # Returns a new Date representing the start of the given day in next week (default is Monday).
      def next_week(day = :monday)
        days_into_week = { :monday => 0, :tuesday => 1, :wednesday => 2, :thursday => 3, :friday => 4, :saturday => 5, :sunday => 6}
        (self + 7).beginning_of_week + days_into_week[day]
      end

      # Returns a new Date representing the start of the month (1st of the month)
      def beginning_of_month
        change(:day => 1)
      end
      alias :at_beginning_of_month :beginning_of_month

      # Returns a new Date representing the end of the month (last day of the month)
      def end_of_month
        change(:day => ::Time.days_in_month( self.month, self.year ))
      end
      alias :at_end_of_month :end_of_month

      # Returns a new Date/DateTime representing the start of the quarter (1st of january, april, july, october; DateTime objects will have time set to 0:00)
      def beginning_of_quarter
        beginning_of_month.change(:month => [10, 7, 4, 1].detect { |m| m <= self.month })
      end
      alias :at_beginning_of_quarter :beginning_of_quarter

      # Returns a new Date/DateTime representing the end of the quarter (last day of march, june, september, december; DateTime objects will have time set to 23:59:59)
      def end_of_quarter
        beginning_of_month.change(:month => [3, 6, 9, 12].detect { |m| m >= self.month }).end_of_month
      end
      alias :at_end_of_quarter :end_of_quarter

      # Returns a new Date/DateTime representing the start of the year (1st of january; DateTime objects will have time set to 0:00)
      def beginning_of_year
        change(:month => 1, :day => 1)
      end
      alias :at_beginning_of_year :beginning_of_year

      # Returns a new Time representing the end of the year (31st of december; DateTime objects will have time set to 23:59:59)
      def end_of_year
        change(:month => 12, :day => 31)
      end
      alias :at_end_of_year :end_of_year

      # Convenience method which returns a new Date/DateTime representing the time 1 day ago
      def yesterday
        self - 1
      end

      # Convenience method which returns a new Date/DateTime representing the time 1 day since the instance time
      def tomorrow
        self + 1
      end

      # Convert to a formatted string. See DATE_FORMATS for predefined formats.
      #
      # This method is aliased to <tt>to_s</tt>.
      #
      # ==== Examples
      #   date = Date.new(2007, 11, 10)       # => Sat, 10 Nov 2007
      #
      #   date.to_formatted_s(:db)            # => "2007-11-10"
      #   date.to_s(:db)                      # => "2007-11-10"
      #
      #   date.to_formatted_s(:short)         # => "10 Nov"
      #   date.to_formatted_s(:long)          # => "November 10, 2007"
      #   date.to_formatted_s(:long_ordinal)  # => "November 10th, 2007"
      #   date.to_formatted_s(:rfc822)        # => "10 Nov 2007"
      #
      # == Adding your own time formats to to_formatted_s
      # You can add your own formats to the Date::DATE_FORMATS hash.
      # Use the format name as the hash key and either a strftime string
      # or Proc instance that takes a date argument as the value.
      #
      #   # config/initializers/time_formats.rb
      #   Date::DATE_FORMATS[:month_and_year] = "%B %Y"
      #   Date::DATE_FORMATS[:short_ordinal] = lambda { |date| date.strftime("%B #{date.day.ordinalize}") }
      def to_formatted_s(format = :default)
        if formatter = DATE_FORMATS[format]
          if formatter.respond_to?(:call)
            formatter.call(self).to_s
          else
            strftime(formatter)
          end
        else
          to_default_s
        end
      end

      # Overrides the default inspect method with a human readable one, e.g., "Mon, 21 Feb 2005"
      def readable_inspect
        strftime("%a, %d %b %Y")
      end

      # Converts a Date instance to a Time, where the time is set to the beginning of the day.
      # The timezone can be either :local or :utc (default :local).
      #
      # ==== Examples
      #   date = Date.new(2007, 11, 10)  # => Sat, 10 Nov 2007
      #
      #   date.to_time                   # => Sat Nov 10 00:00:00 0800 2007
      #   date.to_time(:local)           # => Sat Nov 10 00:00:00 0800 2007
      #
      #   date.to_time(:utc)             # => Sat Nov 10 00:00:00 UTC 2007
      def to_time(form = :local)
        ::Time.send("#{form}_time", year, month, day)
      end

      def xmlschema
        to_time.xmlschema
      end
    end
  end
end

class Date
  include Useful::RubyExtensionsFromRails::Date
end
