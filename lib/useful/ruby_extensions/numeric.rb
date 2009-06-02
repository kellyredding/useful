require File.join(File.dirname(__FILE__), 'object')
require File.join(File.dirname(__FILE__), 'string')
require File.join(File.dirname(__FILE__), 'hash')

module Useful
  module RubyExtensions
    module Numeric #:nodoc:

      LOCALES = {
        :en => {
          :currency => {:format => "%u%n", :unit=> '$'},
          :format => {:delimiter => ',', :separator => '.'},
          :defaults => {:precision => 2}
        }
      }

      module ClassMethods; end
      def self.included(klass)
        klass.extend(ClassMethods) if klass.kind_of?(Class)
      end

      module ClassMethods

        def pad_precision(num, opts = {})
          opts[:precision] ||= 2
          opts[:separator] ||= '.'
          opts[:pad_number] ||= 0
          num.to_s.ljust(num.to_s.split(opts[:separator])[0].length + num.to_s.count(opts[:separator]) + opts[:precision].to_i, opts[:pad_number].to_s)
        end

      end

      # Formats a +number+ with grouped thousands using +delimiter+ (e.g., 12,324). You can
      # customize the format in the +options+ hash.
      # => taken and inspired from ActionView::Helpers::NumberHelper (http://api.rubyonrails.org/)
      #
      # ==== Options
      # * <tt>:delimiter</tt>  - Sets the thousands delimiter (defaults to ",").
      # * <tt>:separator</tt>  - Sets the separator between the units (defaults to ".").
      #
      # ==== Examples
      #  12345678.with_delimiter                        # => 12,345,678
      #  12345678.05.with_delimiter                     # => 12,345,678.05
      #  12345678.with_delimiter(:delimiter => ".")     # => 12.345.678
      #  12345678.with_delimiter(:seperator => ",")     # => 12,345,678
      #  98765432.98.with_delimiter(:delimiter => " ", :separator => ",")
      #  # => 98 765 432,98
      def with_delimiter(opts = {})
        number = self.to_s.strip
        opts.symbolize_keys!
        opts[:locale] = :en if opts.empty?
        locale = LOCALES[opts.delete(:locale)]
        opts.merge!(locale[:format]) unless locale.nil?
        opts[:delimiter] ||= ','
        opts[:separator] ||= '.'

        begin
          parts = number.to_s.split('.')
          parts[0].gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{opts[:delimiter]}")
          parts.join(opts[:separator])
        rescue
          number
        end
      end

      # Converts a +number+ with the specified level of <tt>:precision</tt> (e.g., 112.32 has a precision of 2).
      # => taken and inspired from ActionView::Helpers::NumberHelper (http://api.rubyonrails.org/)
      def to_precision(precision = 2)
        rounded_number = (Float(self) * (10 ** precision)).round
        rounded_number = rounded_number.to_f if precision > 0
        (rounded_number / 10 ** precision) rescue self
      end
      
      # Formats a +number+ with the specified level of <tt>:precision</tt> (e.g., 112.32 has a precision of 2).
      # You can customize the format in the +options+ hash.
      # => taken and inspired from ActionView::Helpers::NumberHelper (http://api.rubyonrails.org/)
      #
      # ==== Options
      # * <tt>:precision</tt>  - Sets the level of precision (defaults to 3).
      # * <tt>:separator</tt>  - Sets the separator between the units (defaults to ".").
      # * <tt>:delimiter</tt>  - Sets the thousands delimiter (defaults to "").
      #
      # ==== Examples (:locale => :en)
      #  111.2345.with_precision                    # => 111.235
      #  111.2345.with_precision(:precision => 2)   # => 111.23
      #  13.with_precision(:precision => 5)         # => 13.00000
      #  389.32314.with_precision(:precision => 0)  # => 389
      #  1111.2345.with_precision(:precision => 2, :separator => ',', :delimiter => '.')
      #  # => 1,111.23
      def with_precision(opts = {})
        opts.symbolize_keys!
        opts[:locale] = :en if opts.empty?
        locale = LOCALES[opts.delete(:locale)]
        opts.merge!(locale[:defaults]).merge!(locale[:format]) unless locale.nil?
        opts[:precision] ||= 2
        
        self.class.pad_precision(self.to_precision(opts[:precision]).with_delimiter(opts.only(:separator, :delimiter)), opts) rescue self
      end

      # Formats a +number+ as a percentage string (e.g., 65%). You can customize the
      # format in the +options+ hash.
      #
      # ==== Options
      # * <tt>:precision</tt>  - Sets the level of precision (defaults to 2).
      # * <tt>:separator</tt>  - Sets the separator between the units (defaults to ".").
      # * <tt>:delimiter</tt>  - Sets the thousands delimiter (defaults to "").
      #
      # ==== Examples
      #  100.to_percentage                                        # => 100.00%
      #  100.to_percentage(:precision => 0)                       # => 100%
      #  1000.to_percentage(:delimiter => '.', :separator => ',') # => 1.000,00%
      #  302.24398923423.to_percentage(:precision => 5)           # => 302.24399%
      def to_percentage(opts = {})
        opts.symbolize_keys!
        opts[:locale] = :en if opts.empty?
        locale = LOCALES[opts.delete(:locale)]
        opts.merge!(locale[:defaults]).merge!(locale[:format]) unless locale.nil?

        "#{self.with_precision(opts.only(:precision, :separator, :delimiter))}%" rescue self
      end

      # Formats a +number+ into a currency string (e.g., $13.65). You can customize the format
      # in the +options+ hash.
      # => taken and inspired from ActionView::Helpers::NumberHelper (http://api.rubyonrails.org/)
      #
      # ==== Options
      # * <tt>:precision</tt>  -  Sets the level of precision (defaults to 2).
      # * <tt>:unit</tt>       - Sets the denomination of the currency (defaults to "$").
      # * <tt>:separator</tt>  - Sets the separator between the units (defaults to ".").
      # * <tt>:delimiter</tt>  - Sets the thousands delimiter (defaults to ",").
      # * <tt>:format</tt>     - Sets the format of the output string (defaults to "%u%n"). The field types are:
      #
      #     %u  The currency unit
      #     %n  The number
      #
      # ==== Examples (:locale => :en)
      #  1234567890.50.to_currency                    # => $1,234,567,890.50
      #  1234567890.506.to_currency                   # => $1,234,567,890.51
      #  1234567890.506.to_currency(:precision => 3)  # => $1,234,567,890.506
      #
      #  1234567890.50.to_currency(:unit => "&pound;", :separator => ",", :delimiter => "")
      #  # => &pound;1234567890,50
      #  1234567890.50.to_currency(:unit => "&pound;", :separator => ",", :delimiter => "", :format => "%n %u")
      #  # => 1234567890,50 &pound;
      def to_currency(opts = {})
        opts.symbolize_keys!
        opts[:locale] = :en if opts.empty?
        locale = LOCALES[opts.delete(:locale)]
        opts.merge!(locale[:defaults]).merge!(locale[:format]).merge!(locale[:currency]) unless locale.nil?

        opts[:format].gsub(/%n/, self.with_precision(opts.only(:precision, :delimiter, :separator))).gsub(/%u/, opts[:unit]) rescue self
      end

      # Provides methods for converting numbers into formatted strings.
      # Methods are provided for phone numbers, currency, percentage,
      # precision, positional notation, and file size.
      # => taken and inspired from ActionView::Helpers::NumberHelper (http://api.rubyonrails.org/)

      # Formats a +number+ into a US phone number (e.g., (555) 123-9876). You can customize the format
      # in the +options+ hash.
      #
      # ==== Options
      # * <tt>:area_code</tt>  - Adds parentheses around the area code.
      # * <tt>:delimiter</tt>  - Specifies the delimiter to use (defaults to "-").
      # * <tt>:extension</tt>  - Specifies an extension to add to the end of the
      #   generated number.
      # * <tt>:country_code</tt>  - Sets the country code for the phone number.
      #
      # ==== Examples
      #  5551234.to_phone                                           # => 555-1234
      #  1235551234.to_phone                                        # => 123-555-1234
      #  1235551234.to_phone(:area_code => true)                    # => (123) 555-1234
      #  1235551234.to_phone(:delimiter => " ")                     # => 123 555 1234
      #  1235551234.to_phone(:area_code => true, :extension => 555) # => (123) 555-1234 x 555
      #  1235551234.to_phone(:country_code => 1)                    # => +1-123-555-1234
      #  1235551234.to_phone({ :country_code => 1,
      #    :extension => 1343, :delimiter => "." })                 # => +1.123.555.1234 x 1343
      def to_phone(opts={})
        number = self.to_s.strip
        opts.symbolize_keys!
        opts[:delimiter] ||= '-'
        opts[:extension] = opts[:extension].to_s.strip unless opts[:extension].nil?

        begin
          str = ""
          str << "+#{opts[:country_code]}#{opts[:delimiter]}" unless opts[:country_code].blank?
          str << if opts[:area_code]
            number.gsub!(/([0-9]{1,3})([0-9]{3})([0-9]{4}$)/,"(\\1) \\2#{opts[:delimiter]}\\3")
          else
            number.gsub!(/([0-9]{0,3})([0-9]{3})([0-9]{4})$/,"\\1#{opts[:delimiter]}\\2#{opts[:delimiter]}\\3")
            number.starts_with?('-') ? number.slice!(1..-1) : number
          end
          str << " x #{opts[:extension]}" unless opts[:extension].blank?
          str
        rescue
          number
        end
      end

      STORAGE_UNITS = [:byte, :kb, :mb, :gb, :tb].freeze

      # Formats the bytes in +size+ into a more understandable representation
      # (e.g., giving it 1500 yields 1.5 KB). This method is useful for
      # reporting file sizes to users. This method returns nil if
      # +size+ cannot be converted into a number. You can customize the
      # format in the +options+ hash.
      #
      # ==== Options
      # * <tt>:precision</tt>  - Sets the level of precision (defaults to 1).
      # * <tt>:separator</tt>  - Sets the separator between the units (defaults to ".").
      # * <tt>:delimiter</tt>  - Sets the thousands delimiter (defaults to "").
      #
      # ==== Examples
      #  number_to_human_size(123)                                          # => 123 Bytes
      #  number_to_human_size(1234)                                         # => 1.2 KB
      #  number_to_human_size(12345)                                        # => 12.1 KB
      #  number_to_human_size(1234567)                                      # => 1.2 MB
      #  number_to_human_size(1234567890)                                   # => 1.1 GB
      #  number_to_human_size(1234567890123)                                # => 1.1 TB
      #  number_to_human_size(1234567, :precision => 2)                     # => 1.18 MB
      #  number_to_human_size(483989, :precision => 0)                      # => 473 KB
      #  number_to_human_size(1234567, :precision => 2, :separator => ',')  # => 1,18 MB
      #
      # You can still use <tt>number_to_human_size</tt> with the old API that accepts the
      # +precision+ as its optional second parameter:
      #  number_to_human_size(1234567, 2)    # => 1.18 MB
      #  number_to_human_size(483989, 0)     # => 473 KB
      def number_to_human_size(number, *args)
        return nil if number.nil?

        options = args.extract_options!
        options.symbolize_keys!

        defaults = I18n.translate(:'number.format', :locale => options[:locale], :raise => true) rescue {}
        human    = I18n.translate(:'number.human.format', :locale => options[:locale], :raise => true) rescue {}
        defaults = defaults.merge(human)

        unless args.empty?
          ActiveSupport::Deprecation.warn('number_to_human_size takes an option hash ' +
            'instead of a separate precision argument.', caller)
          precision = args[0] || defaults[:precision]
        end

        precision ||= (options[:precision] || defaults[:precision])
        separator ||= (options[:separator] || defaults[:separator])
        delimiter ||= (options[:delimiter] || defaults[:delimiter])

        storage_units_format = I18n.translate(:'number.human.storage_units.format', :locale => options[:locale], :raise => true)

        if number.to_i < 1024
          unit = I18n.translate(:'number.human.storage_units.units.byte', :locale => options[:locale], :count => number.to_i, :raise => true)
          storage_units_format.gsub(/%n/, number.to_i.to_s).gsub(/%u/, unit)
        else
          max_exp  = STORAGE_UNITS.size - 1
          number   = Float(number)
          exponent = (Math.log(number) / Math.log(1024)).to_i # Convert to base 1024
          exponent = max_exp if exponent > max_exp # we need this to avoid overflow for the highest unit
          number  /= 1024 ** exponent

          unit_key = STORAGE_UNITS[exponent]
          unit = I18n.translate(:"number.human.storage_units.units.#{unit_key}", :locale => options[:locale], :count => number, :raise => true)

          begin
            escaped_separator = Regexp.escape(separator)
            formatted_number = number_with_precision(number,
              :precision => precision,
              :separator => separator,
              :delimiter => delimiter
            ).sub(/(\d)(#{escaped_separator}[1-9]*)?0+\z/, '\1\2').sub(/#{escaped_separator}\z/, '')
            storage_units_format.gsub(/%n/, formatted_number).gsub(/%u/, unit)
          rescue
            number
          end
        end
      end
      
    end
  end
end

class Numeric
  include Useful::RubyExtensions::Numeric
end

