module Useful; end
module Useful::RubyExtensions; end

require 'useful/ruby_extensions/integer' unless 1.respond_to?(:to_time_at)

module Useful::RubyExtensions::String
  
  EMAIL_REGEXP = /\A([\w\.\-\+]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  module ClassMethods

    # adds the contents of a2 to a1, removing duplicates
    def hsub(string, hash)
      hash.each {|k,v| string.gsub!(":#{k}",v.to_s)}
      string
    end
    
    # does some CGI escaping on a string
    CGI_ESCAPE_MAP = {
      '+'    => '%20'
    }.freeze
    def cgi_escape(string)
      require 'cgi' unless defined?(::CGI) && defined?(::CGI::escape)
      ::CGI.escape(string).gsub(/(\+)/) { CGI_ESCAPE_MAP[$1] }
    end
    
    def match?(string, pattern)
      !string.match(pattern).nil?
    end
    
    def valid_email?(string)
      match?(string, EMAIL_REGEXP)
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
      self.class.hsub(self.dup, hash)
    end
    # substitutes the keys in hash that exist in the string, with values of hash
    def hsub!(hash)
      self.class.hsub(self, hash)
    end
    
    # will destructively empty out a string, making its value ""
    def empty!
      self.replace("")
    end

    def cgi_escape
      self.class.cgi_escape(self)
    end

    def cgi_escape!
      self.replace(self.class.cgi_escape(self))
    end

    def match?(pattern)
      self.class.match?(self, pattern)
    end

    def valid_email?
      self.class.valid_email?(self)
    end

    def show_regexp(re)
      self.class.show_regexp(self, re)
    end
    
    def to_boolean
      self =~ /^(false|0)$/i ? false : true
    end
    
    def from_currency_to_f
      self.gsub(/[^0-9.-]/,'').to_f
    end
    
    def to_time_at
      self.to_i.to_time_at
    end

  end
  
  module FromActivesupport
    
    module ClassMethods
      
      # By default, +camelize+ converts strings to UpperCamelCase. If the argument to +camelize+
      # is set to <tt>:lower</tt> then +camelize+ produces lowerCamelCase.
      #
      # +camelize+ will also convert '/' to '::' which is useful for converting paths to namespaces.
      #
      # Examples:
      #   "active_record".camelize                # => "ActiveRecord"
      #   "active_record".camelize(:lower)        # => "activeRecord"
      #   "active_record/errors".camelize         # => "ActiveRecord::Errors"
      #   "active_record/error".camelize(:lower)  # => "activeRecord::Error"
      def camelize(lower_case_and_underscored_word, first_letter_in_uppercase = true)
        if first_letter_in_uppercase
          lower_case_and_underscored_word.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
        else
          lower_case_and_underscored_word[0..0].downcase + camelize(lower_case_and_underscored_word)[1..-1]
        end
      end unless ::String.respond_to?('camelize')

      # Create a class name from a string like Rails does for table names to models.
      # => Note: unlike Rails, this one does not use inflectors to singularize
      # => Note: this returns a string and not a Class. (To convert to an actual class
      # follow +classify+ with +constantize+.)
      #
      # Examples:
      #   "egg_and_hams".classify         # => "EggAndHams"
      #   "active_record/errors".classify # => "ActiveRecord::Errors"
      #   "active_record.error".classify  # => "Error"
      def classify(class_str)
        # strip out any leading schema name
        camelize(class_str.to_s.sub(/.*\./, ''))
      end unless ::String.respond_to?('classify')
      
      # Capitalizes the first word and turns underscores into spaces and strips a
      # trailing "_id", if any. Like +titleize+, this is meant for creating pretty output.
      #
      # Examples:
      #   "employee_salary" # => "Employee salary"
      #   "author_id"       # => "Author"
      def humanize(lower_case_and_underscored_word)
        result = lower_case_and_underscored_word.to_s.dup
        result.gsub(/_id$/, "").gsub(/_/, " ").capitalize
      end unless ::String.respond_to?('humanize')

      # Capitalizes all the words and replaces some characters in the string to create
      # a nicer looking title. +titleize+ is meant for creating pretty output. It is not
      # used in the Rails internals.
      #
      # Examples:
      #   "man from the boondocks".titleize # => "Man From The Boondocks"
      #   "x-men: the last stand".titleize  # => "X Men: The Last Stand"
      def titleize(word)
        humanize(underscore(word)).gsub(/\b('?[a-z])/) { $1.capitalize }
      end unless ::String.respond_to?('titleize')

      # The reverse of +camelize+. Makes an underscored, lowercase form from the expression in the string.
      #
      # Changes '::' to '/' to convert namespaces to paths.
      #
      # Examples:
      #   "ActiveRecord".underscore         # => "active_record"
      #   "ActiveRecord::Errors".underscore # => active_record/errors
      def underscore(camel_cased_word)
        camel_cased_word.to_s.gsub(/::/, '/').
          gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
          gsub(/([a-z\d])([A-Z])/,'\1_\2').
          tr("-", "_").
          downcase
      end unless ::String.respond_to?('underscore')

      # Replaces underscores with dashes in the string.
      #
      # Example:
      #   "puni_puni" # => "puni-puni"
      def dasherize(underscored_word)
        underscored_word.gsub(/_/, '-')
      end unless ::String.respond_to?('dasherize')

      # makes string suitable for a dashed url parameter string
      #
      # Example:
      #   "ActiveRecord" # => "active-record"
      #   "Active Record is_awesome" # => "active-record-is-awesome"
      def parameterize(phrase)
        phrase.underscore.gsub(/\s+/, '_').dasherize
      end unless ::String.respond_to?('parameterize')

      # Removes the module part from the expression in the string.
      #
      # Examples:
      #   "ActiveRecord::CoreExtensions::String::Inflections".demodulize # => "Inflections"
      #   "Inflections".demodulize                                       # => "Inflections"
      def demodulize(class_name_in_module)
        class_name_in_module.to_s.gsub(/^.*::/, '')
      end unless ::String.respond_to?('demodulize')

      # Ruby 1.9 introduces an inherit argument for Module#const_get and
      # #const_defined? and changes their default behavior.
      if Module.method(:const_get).arity == 1
        # Tries to find a constant with the name specified in the argument string:
        #
        #   "Module".constantize     # => Module
        #   "Test::Unit".constantize # => Test::Unit
        #
        # The name is assumed to be the one of a top-level constant, no matter whether
        # it starts with "::" or not. No lexical context is taken into account:
        #
        #   C = 'outside'
        #   module M
        #     C = 'inside'
        #     C               # => 'inside'
        #     "C".constantize # => 'outside', same as ::C
        #   end
        #
        # NameError is raised when the name is not in CamelCase or the constant is
        # unknown.
        def constantize(camel_cased_word)
          names = camel_cased_word.split('::')
          names.shift if names.empty? || names.first.empty?

          constant = ::Object
          names.each do |name|
            constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
          end
          constant
        end unless ::String.respond_to?('constantize')
      else
        def constantize(camel_cased_word) #:nodoc:
          names = camel_cased_word.split('::')
          names.shift if names.empty? || names.first.empty?

          constant = ::Object
          names.each do |name|
            constant = constant.const_get(name, false) || constant.const_missing(name)
          end
          constant
        end unless ::String.respond_to?('constantize')
      end

    end
    
    module InstanceMethods
      
      def camelize(first_letter = :upper)
        case first_letter
          when :upper then ::String.camelize(self, true)
          when :lower then ::String.camelize(self, false)
        end
      end unless "".respond_to?('camelize')
      alias_method :camelcase, :camelize unless "".respond_to?('camelcase')

      def classify
        self.class.classify(self)
      end unless "".respond_to?('classify')

      def humanize
        self.class.humanize(self)
      end unless "".respond_to?('humanize')

      def titleize
        self.class.titleize(self)
      end unless "".respond_to?('titleize')

      def underscore
        self.class.underscore(self)
      end unless "".respond_to?('underscore')

      def dasherize
        self.class.dasherize(self)
      end unless "".respond_to?('dasherize')

      def parameterize
        self.class.parameterize(self)
      end unless "".respond_to?('parameterize')

      def demodulize
        self.class.demodulize(self)
      end unless "".respond_to?('demodulize')

      def constantize
        self.class.constantize(self)
      end unless "".respond_to?('constantize')

      def ends_with?(suffix)
        suffix = suffix.to_s
        self[-suffix.length, suffix.length] == suffix      
      end unless "".respond_to?('ends_with?')

      def starts_with?(prefix)
        prefix = prefix.to_s
        self[0, prefix.length] == prefix
      end unless "".respond_to?('starts_with?')

      def to_datetime
        ::DateTime.civil(*::Date._parse(self, false).values_at(:year, :mon, :mday, :hour, :min, :sec).map { |arg| arg || 0 }) rescue nil
      end unless "".respond_to?('to_datetime')

      def to_date
        ::Date.civil(*::Date._parse(self, false).values_at(:year, :mon, :mday).map { |arg| arg || 0 }) rescue nil
      end unless "".respond_to?('to_date')
      
    end
    
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.extend         FromActivesupport::ClassMethods
    receiver.send :include, InstanceMethods
    receiver.send :include, FromActivesupport::InstanceMethods
  end
  
end

class String
  include Useful::RubyExtensions::String
end
