module Useful; end
module Useful::RubyExtensionsFromRails; end

module Useful::RubyExtensionsFromRails::String
  
  module ClassMethods; end
  def self.included(klass)
    klass.extend(ClassMethods) if klass.kind_of?(Class)
  end

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
    #   "active_record/errors".camelize(:lower) # => "activeRecord::Errors"
    def camelize(lower_case_and_underscored_word, first_letter_in_uppercase = true)
      if first_letter_in_uppercase
        lower_case_and_underscored_word.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
      else
        lower_case_and_underscored_word[0..0].downcase + camelize(lower_case_and_underscored_word)[1..-1]
      end
    end

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
    end

    # Replaces underscores with dashes in the string.
    #
    # Example:
    #   "puni_puni" # => "puni-puni"
    def dasherize(underscored_word)
      underscored_word.gsub(/_/, '-')
    end

    # Removes the module part from the expression in the string.
    #
    # Examples:
    #   "ActiveRecord::CoreExtensions::String::Inflections".demodulize # => "Inflections"
    #   "Inflections".demodulize                                       # => "Inflections"
    def demodulize(class_name_in_module)
      class_name_in_module.to_s.gsub(/^.*::/, '')
    end

    # Create a class name from a string like Rails does for table names to models.
    # Note that this returns a string and not a Class. (To convert to an actual class
    # follow +classify+ with +constantize+.)
    #
    # Examples:
    #   "egg_and_hams".classify # => "EggAndHam"
    #   "posts".classify        # => "Post"
    #
    # Singular names are not handled correctly:
    #   "business".classify     # => "Busines"
    def classify(class_str)
      # strip out any leading schema name
      camelize(class_str.to_s.sub(/.*\./, ''))
    end

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
      end
    else
      def constantize(camel_cased_word) #:nodoc:
        names = camel_cased_word.split('::')
        names.shift if names.empty? || names.first.empty?

        constant = ::Object
        names.each do |name|
          constant = constant.const_get(name, false) || constant.const_missing(name)
        end
        constant
      end
    end

  end #ClassMethods

  def camelize(first_letter = :upper)
    case first_letter
      when :upper then ::String.camelize(self, true)
      when :lower then ::String.camelize(self, false)
    end
  end
  alias_method :camelcase, :camelize

  def underscore
    self.class.underscore(self)
  end

  def dasherize
    self.class.dasherize(self)
  end

  def demodulize
    self.class.demodulize(self)
  end

  def classify
    self.class.classify(self)
  end
  
  def constantize
    self.class.constantize(self)
  end
  
  def ends_with?(suffix)
    suffix = suffix.to_s
    self[-suffix.length, suffix.length] == suffix      
  end
  
  def starts_with?(prefix)
    prefix = prefix.to_s
    self[0, prefix.length] == prefix
  end
  
  def to_datetime
    ::DateTime.civil(*::Date._parse(self, false).values_at(:year, :mon, :mday, :hour, :min, :sec).map { |arg| arg || 0 }) rescue nil
  end

  def to_date
    ::Date.civil(*::Date._parse(self, false).values_at(:year, :mon, :mday).map { |arg| arg || 0 }) rescue nil
  end

end

class String
  include Useful::RubyExtensionsFromRails::String
end
