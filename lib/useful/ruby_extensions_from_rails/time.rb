require File.join(File.dirname(__FILE__), 'object') unless Object.new.respond_to?(:acts_like?)
require File.join(File.dirname(__FILE__), 'duration')
require File.join(File.dirname(__FILE__), 'numeric')

module Useful
  module RubyExtensionsFromRails
    module Time

      def self.included(base) #:nodoc:
        base.extend ClassMethods
        base.class_eval do
          alias_method :to_default_s, :to_s
          alias_method :to_s, :to_formatted_s
        end
      end

      COMMON_YEAR_DAYS_IN_MONTH = [nil, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
      DATE_FORMATS = {
        :db           => "%Y-%m-%d %H:%M:%S",
        :number       => "%Y%m%d%H%M%S",
        :time         => "%H:%M",
        :short        => "%d %b %H:%M",
        :long         => "%B %d, %Y %H:%M",
        :long_ordinal => lambda { |time| time.strftime("%B #{time.day.ordinalize}, %Y %H:%M") },
        :rfc822       => lambda { |time| time.strftime("%a, %d %b %Y %H:%M:%S #{time.formatted_offset(false)}") }
      }

      module ClassMethods
        # Return the number of days in the given month.
        # If no year is specified, it will use the current year.
        def days_in_month(month, year = now.year)
          return 29 if month == 2 && ::Date.gregorian_leap?(year)
          COMMON_YEAR_DAYS_IN_MONTH[month]
        end

        # Returns a new Time if requested year can be accommodated by Ruby's Time class
        # (i.e., if year is within either 1970..2038 or 1902..2038, depending on system architecture);
        # otherwise returns a DateTime
        def time_with_datetime_fallback(utc_or_local, year, month=1, day=1, hour=0, min=0, sec=0, usec=0)
          ::Time.send(utc_or_local, year, month, day, hour, min, sec, usec)
        end

        # Wraps class method +time_with_datetime_fallback+ with +utc_or_local+ set to <tt>:utc</tt>.
        def utc_time(*args)
          time_with_datetime_fallback(:utc, *args)
        end

        # Wraps class method +time_with_datetime_fallback+ with +utc_or_local+ set to <tt>:local</tt>.
        def local_time(*args)
          time_with_datetime_fallback(:local, *args)
        end

        # Returns Time.now
        def current
          ::Time.now
        end
        
      end

      # Enable more predictable duck-typing on Time-like classes. See
      # Object#acts_like?.
      def acts_like_time?
        true
      end

      # Tells whether the Time object's time lies in the past
      def past?
        self < ::Time.current
      end

      # Tells whether the Time object's time is today
      def today?
        self.to_date == ::Date.current
      end

      # Tells whether the Time object's time lies in the future
      def future?
        self > ::Time.current
      end

      # Seconds since midnight: Time.now.seconds_since_midnight
      def seconds_since_midnight
        self.to_i - self.change(:hour => 0).to_i + (self.usec/1.0e+6)
      end

      # Returns a new Time where one or more of the elements have been changed according to the +options+ parameter. The time options
      # (hour, minute, sec, usec) reset cascadingly, so if only the hour is passed, then minute, sec, and usec is set to 0. If the hour and
      # minute is passed, then sec and usec is set to 0.
      def change(options)
        ::Time.send(
          self.utc? ? :utc_time : :local_time,
          options[:year]  || self.year,
          options[:month] || self.month,
          options[:day]   || self.day,
          options[:hour]  || self.hour,
          options[:min]   || (options[:hour] ? 0 : self.min),
          options[:sec]   || ((options[:hour] || options[:min]) ? 0 : self.sec),
          options[:usec]  || ((options[:hour] || options[:min] || options[:sec]) ? 0 : self.usec)
        )
      end

      # Uses Date to provide precise Time calculations for years, months, and days.
      # The +options+ parameter takes a hash with any of these keys: <tt>:years</tt>,
      # <tt>:months</tt>, <tt>:weeks</tt>, <tt>:days</tt>, <tt>:hours</tt>,
      # <tt>:minutes</tt>, <tt>:seconds</tt>.
      def advance(options)
        unless options[:weeks].nil?
          options[:weeks], partial_weeks = options[:weeks].divmod(1)
          options[:days] = (options[:days] || 0) + 7 * partial_weeks
        end
        
        unless options[:days].nil?
          options[:days], partial_days = options[:days].divmod(1)
          options[:hours] = (options[:hours] || 0) + 24 * partial_days
        end
        
        d = to_date.advance(options)
        time_advanced_by_date = change(:year => d.year, :month => d.month, :day => d.day)
        seconds_to_advance = (options[:seconds] || 0) + (options[:minutes] || 0) * 60 + (options[:hours] || 0) * 3600
        seconds_to_advance == 0 ? time_advanced_by_date : time_advanced_by_date.since(seconds_to_advance)
      end

      # Returns a new Time representing the time a number of seconds ago, this is basically a wrapper around the Numeric extension
      def ago(seconds)
        self.since(-seconds)
      end

      # Returns a new Time representing the time a number of seconds since the instance time, this is basically a wrapper around
      # the Numeric extension.
      def since(seconds)
        f = seconds.since(self)
        if Useful::RubyExtensionsFromRails::Duration === seconds
          f
        else
          initial_dst = self.dst? ? 1 : 0
          final_dst   = f.dst? ? 1 : 0
          (seconds.abs >= 86400 && initial_dst != final_dst) ? f + (initial_dst - final_dst).hours : f
        end
      end
      alias :in :since

      # Returns a new Time representing the time a number of specified months ago
      def months_ago(months)
        advance(:months => -months)
      end

      # Returns a new Time representing the time a number of specified months in the future
      def months_since(months)
        advance(:months => months)
      end

      # Returns a new Time representing the time a number of specified years ago
      def years_ago(years)
        advance(:years => -years)
      end

      # Returns a new Time representing the time a number of specified years in the future
      def years_since(years)
        advance(:years => years)
      end

      # Short-hand for years_ago(1)
      def last_year
        years_ago(1)
      end

      # Short-hand for years_since(1)
      def next_year
        years_since(1)
      end

      # Short-hand for months_ago(1)
      def last_month
        months_ago(1)
      end

      # Short-hand for months_since(1)
      def next_month
        months_since(1)
      end

      # Returns a new Time representing the start of the day (0:00)
      def beginning_of_day
        (self - self.seconds_since_midnight).change(:usec => 0)
      end
      alias :midnight :beginning_of_day
      alias :at_midnight :beginning_of_day
      alias :at_beginning_of_day :beginning_of_day

      # Returns a new Time representing the end of the day (23:59:59)
      def end_of_day
        change(:hour => 23, :min => 59, :sec => 59)
      end
      alias :at_end_of_day :end_of_day

      # Returns a new Time representing the "start" of this week (Monday, 0:00)
      def beginning_of_week
        days_to_monday = self.wday!=0 ? self.wday-1 : 6
        (self - days_to_monday.days).midnight
      end
      alias :monday :beginning_of_week
      alias :at_beginning_of_week :beginning_of_week

      # Returns a new Time representing the end of this week (Sunday, 23:59:59)
      def end_of_week
        days_to_sunday = self.wday!=0 ? 7-self.wday : 0
        (self + days_to_sunday.days).end_of_day
      end
      alias :at_end_of_week :end_of_week

      # Returns a new Time representing the start of the given day in next week (default is Monday).
      def next_week(day = :monday)
        days_into_week = { :monday => 0, :tuesday => 1, :wednesday => 2, :thursday => 3, :friday => 4, :saturday => 5, :sunday => 6}
        since(1.week).beginning_of_week.since(days_into_week[day].day).change(:hour => 0)
      end

      # Returns a new Time representing the start of the month (1st of the month, 0:00)
      def beginning_of_month
        #self - ((self.mday-1).days + self.seconds_since_midnight)
        change(:day => 1,:hour => 0, :min => 0, :sec => 0, :usec => 0)
      end
      alias :at_beginning_of_month :beginning_of_month

      # Returns a new Time representing the end of the month (last day of the month, 0:00)
      def end_of_month
        #self - ((self.mday-1).days + self.seconds_since_midnight)
        last_day = ::Time.days_in_month( self.month, self.year )
        change(:day => last_day, :hour => 23, :min => 59, :sec => 59, :usec => 0)
      end
      alias :at_end_of_month :end_of_month

      # Returns  a new Time representing the start of the quarter (1st of january, april, july, october, 0:00)
      def beginning_of_quarter
        beginning_of_month.change(:month => [10, 7, 4, 1].detect { |m| m <= self.month })
      end
      alias :at_beginning_of_quarter :beginning_of_quarter

      # Returns a new Time representing the end of the quarter (last day of march, june, september, december, 23:59:59)
      def end_of_quarter
        beginning_of_month.change(:month => [3, 6, 9, 12].detect { |m| m >= self.month }).end_of_month
      end
      alias :at_end_of_quarter :end_of_quarter

      # Returns  a new Time representing the start of the year (1st of january, 0:00)
      def beginning_of_year
        change(:month => 1,:day => 1,:hour => 0, :min => 0, :sec => 0, :usec => 0)
      end
      alias :at_beginning_of_year :beginning_of_year

      # Returns a new Time representing the end of the year (31st of december, 23:59:59)
      def end_of_year
        change(:month => 12,:day => 31,:hour => 23, :min => 59, :sec => 59)
      end
      alias :at_end_of_year :end_of_year

      # Convenience method which returns a new Time representing the time 1 day ago
      def yesterday
        advance(:days => -1)
      end

      # Convenience method which returns a new Time representing the time 1 day since the instance time
      def tomorrow
        advance(:days => 1)
      end

      # Converts to a formatted string. See DATE_FORMATS for builtin formats.
      #
      # This method is aliased to <tt>to_s</tt>.
      #
      #   time = Time.now                     # => Thu Jan 18 06:10:17 CST 2007
      #
      #   time.to_formatted_s(:time)          # => "06:10:17"
      #   time.to_s(:time)                    # => "06:10:17"
      #
      #   time.to_formatted_s(:db)            # => "2007-01-18 06:10:17"
      #   time.to_formatted_s(:number)        # => "20070118061017"
      #   time.to_formatted_s(:short)         # => "18 Jan 06:10"
      #   time.to_formatted_s(:long)          # => "January 18, 2007 06:10"
      #   time.to_formatted_s(:long_ordinal)  # => "January 18th, 2007 06:10"
      #   time.to_formatted_s(:rfc822)        # => "Thu, 18 Jan 2007 06:10:17 -0600"
      #
      # == Adding your own time formats to +to_formatted_s+
      # You can add your own formats to the Time::DATE_FORMATS hash.
      # Use the format name as the hash key and either a strftime string
      # or Proc instance that takes a time argument as the value.
      #
      #   # config/initializers/time_formats.rb
      #   Time::DATE_FORMATS[:month_and_year] = "%B %Y"
      #   Time::DATE_FORMATS[:short_ordinal] = lambda { |time| time.strftime("%B #{time.day.ordinalize}") }
      def to_formatted_s(format = :default)
        return to_default_s unless formatter = DATE_FORMATS[format]
        formatter.respond_to?(:call) ? formatter.call(self).to_s : strftime(formatter)
      end
      
      # Returns the UTC offset as an +HH:MM formatted string.
      #
      #   Time.local(2000).formatted_offset         # => "-06:00"
      #   Time.local(2000).formatted_offset(false)  # => "-0600"
      def formatted_offset(colon = true, alternate_utc_string = nil)
        utc? && alternate_utc_string || utc_offset.to_utc_offset_s(colon)
      end

      # Converts a Time object to a Date, dropping hour, minute, and second precision.
      #
      #   my_time = Time.now  # => Mon Nov 12 22:59:51 -0500 2007
      #   my_time.to_date     # => Mon, 12 Nov 2007
      #
      #   your_time = Time.parse("1/13/2009 1:13:03 P.M.")  # => Tue Jan 13 13:13:03 -0500 2009
      #   your_time.to_date                                 # => Tue, 13 Jan 2009
      def to_date
        ::Date.new(year, month, day)
      end

    end
  end
end

class Time
  include Useful::RubyExtensionsFromRails::Time
end
