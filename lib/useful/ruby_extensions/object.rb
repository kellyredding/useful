require 'stringio'
require 'useful/ruby_extensions/nil_class'

module Useful; end
module Useful::RubyExtensions; end

module Useful::RubyExtensions::Object

  def false?
    self == false
  end
  alias_method :is_false?, :false?

  def true?
    self == true
  end
  alias_method :is_true?, :true?

  def capture_std_output
    out = ::StringIO.new
    err = ::StringIO.new
    $stdout = out
    $stderr = err
    yield
    return out, err
  ensure
    $stdout = STDOUT
    $stderr = STDERR
  end

  # Invokes a system command using `` and
  # pass the status and result to a given block
  def sudo(cmd, logger=nil, &block)
    begin
      require 'open4' unless defined?(::Open4)
    rescue LoadError => err
      puts "you need open4 to run the sudo helper: gem install open4"
    else
      logger.debug "`sudo #{cmd}` ..." if logger && logger.respond_to?(:debug)
      result = {}
      status = Open4.popen4("sudo #{cmd}") do |pid, stdin_io, stdout_io, stderr_io|
        result[:out] = stdout_io.gets
        result[:err] = stderr_io.gets
      end
      if block
        block.call(status, status.success? ? result[:out] : result[:err])
      else
        status
      end
    end
  end

  module FromActivesupport

    def blank?
      self.nil? || self.false? || (self.respond_to?(:empty?) ? self.empty? : false)
    end unless ::Object.new.respond_to?('blank?')

    def returning(value)
      warn "[DEPRECATION] `returning` is deprecated.  Please use `tap` instead."
        yield(value)
      value
    end unless ::Object.new.respond_to?('returning')

    def tap
      warn "[DEPRECATION] `tap` will be deprecated because it is part of the object kernel in 1.8.7 up."
      yield self
      self
    end unless ::Object.new.respond_to?('tap')

    # Invokes the method identified by the symbol +method+, passing it any arguments
    # and/or the block specified, just like the regular Ruby <tt>Object#send</tt> does.
    #
    # *Unlike* that method however, a +NoMethodError+ exception will *not* be raised
    # and +nil+ will be returned instead, if the receiving object is a +nil+ object or NilClass.
    #
    # ==== Examples
    #
    # Without try
    #   @person && @person.name
    # or
    #   @person ? @person.name : nil
    #
    # With try
    #   @person.try(:name)
    #
    # +try+ also accepts arguments and/or a block, for the method it is trying
    #   Person.try(:find, 1)
    #   @people.try(:collect) {|p| p.name}
    #--
    # This method definition below is for rdoc purposes only. The alias_method call
    # below overrides it as an optimization since +try+ behaves like +Object#send+,
    # unless called on +NilClass+.
    # => see try method definition on the NilClass extensions for details.
    unless ::Object.new.respond_to?('try')
      def try(method, *args, &block)
        send(method, *args, &block)
      end
      remove_method :try
      alias_method :try, :__send__
    end

  end

  def self.included(receiver)
    receiver.send :include, FromActivesupport
  end

end

class Object
  include Useful::RubyExtensions::Object
end
