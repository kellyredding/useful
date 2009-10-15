module Useful; end
module Useful::RubyExtensions; end

require 'useful/ruby_extensions_from_rails/object' unless Object.new.respond_to?(:blank?)
require 'useful/ruby_extensions_from_rails/hash' unless Hash.new.respond_to?(:symbolize_keys!)
require 'useful/ruby_extensions_from_rails/string' unless String.new.respond_to?(:starts_with?)
require 'useful/ruby_extensions/hash' unless Hash.new.respond_to?(:only)

module Useful::RubyExtensions::Numeric

  LOCALES = {
    :en => {
      :currency => {:format => "%u%n", :unit=> '$'},
      :storage => {:format => "%n %u", :delimiter => ''},
      :format => {:delimiter => ',', :separator => '.'},
      :defaults => {:precision => 2}
    }
  }.freeze
  STORAGE_UNITS = ['Bytes', 'KB', 'MB', 'GB', 'TB'].freeze

  module ClassMethods

    def pad_precision(num, opts = {})
      opts[:precision] ||= 2
      opts[:separator] ||= '.'
      opts[:pad_number] ||= 0
      num_s = num.to_s
      num_s << opts[:separator] unless num_s.include?(opts[:separator])
      ljust_count = num_s.split(opts[:separator])[0].length
      ljust_count += (num_s.count(opts[:separator]) + opts[:precision].to_i) if opts[:precision] > 0
      num_count = num.to_s.length
      if ljust_count >= num_count
        num_s.ljust(ljust_count, opts[:pad_number].to_s)
      else
        num_s[0..(ljust_count-1)]
      end
    end

  end
  
  module InstanceMethods

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
    #  98765432.98.with_delimiter(:delimiter => " ", :separator => ",")  # => 98 765 432,98
    def with_delimiter(opts = {})
      number = self.to_s.strip
      opts.symbolize_keys!
      opts[:locale] ||= :en
      locale = LOCALES[opts.delete(:locale)]
      opts = locale[:format].merge(opts) unless locale.nil?
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
    #  1111.2345.with_precision                    # => 1111.23
    #  1111.2345.with_precision(:delimiter => ',') # => 1,111.23
    #  111.2345.with_precision(:precision => 3)    # => 111.235
    #  13.with_precision(:precision => 5)          # => 13.00000
    #  389.32314.with_precision(:precision => 0)   # => 389
    #  1111.2345.with_precision(:precision => 3, :separator => ',', :delimiter => '.')  # => 1.111,235
    def with_precision(opts = {})
      opts.symbolize_keys!
      opts[:locale] ||= :en
      opts[:delimiter] ||= '' # don't use a delimiter by default
      locale = LOCALES[opts.delete(:locale)]
      opts = locale[:defaults].merge(locale[:format]).merge(opts) unless locale.nil?
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
      opts[:locale] ||= :en
      locale = LOCALES[opts.delete(:locale)]
      opts = locale[:defaults].merge(locale[:format]).merge(opts) unless locale.nil?

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
      return opts[:zero_display] if opts[:zero_display] && self.to_f == 0.to_f
      opts.symbolize_keys!
      opts[:locale] ||= :en
      locale = LOCALES[opts.delete(:locale)]
      opts = locale[:defaults].merge(locale[:format]).merge(locale[:currency]).merge(opts) unless locale.nil?

      opts[:format].gsub(/%n/, self.with_precision(opts.only(:precision, :delimiter, :separator)).to_s).gsub(/%u/, opts[:unit].to_s) #rescue self
    end

    # Formats the bytes in +size+ into a more understandable representation
    # (e.g., giving it 1500 yields 1.5 KB). This method is useful for
    # reporting file sizes to users. This method returns nil if
    # +size+ cannot be converted into a number. You can customize the
    # format in the +options+ hash.
    #
    # ==== Options
    # * <tt>:precision</tt>  - Sets the level of precision (defaults to 2).
    # * <tt>:separator</tt>  - Sets the separator between the units (defaults to ".").
    # * <tt>:delimiter</tt>  - Sets the thousands delimiter (defaults to "").
    #
    # ==== Examples
    #  123.to_storage_size                                          # => 123 Bytes
    #  1234.to_storage_size                                         # => 1.2 KB
    #  12345.to_storage_size                                        # => 12.1 KB
    #  1234567.to_storage_size                                      # => 1.2 MB
    #  1234567890.to_storage_size                                   # => 1.1 GB
    #  1234567890123.to_storage_size                                # => 1.1 TB
    #  1234567.to_storage_size(:precision => 2)                     # => 1.18 MB
    #  483989.to_storage_size(:precision => 0)                      # => 473 KB
    #  1234567.to_storage_size(:precision => 2, :separator => ',')  # => 1,18 MB
    def to_storage_size(opts = {})
      return nil if self.nil?
      opts.symbolize_keys!
      opt_precision = opts[:precision]
      opts[:locale] ||= :en
      locale = LOCALES[opts.delete(:locale)]
      opts = locale[:defaults].merge(locale[:format]).merge(locale[:storage]).merge(opts) unless locale.nil?
      opts[:format] ||= "%n %u"
      opts[:precision] = 0 unless opt_precision

      value = self.to_f
      unit = ''
      STORAGE_UNITS.each do |storage_unit|
        unit = storage_unit.to_s
        return opts[:format].gsub(/%n/, value.with_precision(opts.only(:precision, :delimiter, :separator)).to_s).gsub(/%u/, unit.to_s) if value < 1024 || storage_unit == STORAGE_UNITS.last
        opts[:precision] = 1 unless opt_precision
        value /= 1024.0
      end
    end

    # Returns the string representation of the number's +parity+.
    #
    # ==== Examples
    #  1.to_parity        # => "odd"
    #  2.to_parity        # => "even"
    def to_parity
      self.to_i.modulo(2).zero? ? 'even' : 'odd'
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

  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end

end

class Numeric
  include Useful::RubyExtensions::Numeric
end

