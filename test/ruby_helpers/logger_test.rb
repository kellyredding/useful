require 'test_helper'
require 'fixtures/ruby_helpers/logging'
require 'ruby-debug'


module RubyHelpers
  class LoggerTest < Test::Unit::TestCase

    context "using RubyHelpers::Logger" do
      context "without overridding the logger method" do
        setup do
          @logging = LoggingNone.new
        end

        should "error" do
          assert_raises Exception do
            @logging.log("test msg")
          end
        end
      end

      context "without providing a log4r interface" do
        setup do
          @logging = LoggingBad.new
        end

        should "error" do
          assert_raises Exception do
            @logging.log("test msg")
          end
        end
      end

      context "providing a log4r interface" do
        setup do
          @logging = LoggingGood.new
        end
        subject { @logging }

        should "have_class_methods" do
          assert LoggingGood.respond_to?(:log), "no :log class method"
          [:debug, :info, :warn, :error].each do |level|
            assert LoggingGood.respond_to?(level), "no :#{level} class method"
          end
          #assert LoggingGood.respond_to?(:benchmark), "no :benchmark class method"
        end
        should "have_instance_methods" do
          assert @logging.respond_to?(:log), "no :log instance method"
          [:debug, :info, :warn, :error].each do |level|
            assert @logging.respond_to?(level), "no :#{level} instance method"
          end
          #assert @logging.respond_to?(:benchmark), "no :benchmark instance method"
        end

        should "log at the debug level" do
          log_msg = @logging.log("a debug level message", :level => :debug)
          assert_match /33;1/, log_msg, "not the debug level"
        end

        should "log at the info level" do
          log_msg = @logging.log("an info level message", :level => :info)
          assert_match /32;1/, log_msg, "not the info level"
        end

        should "log at the warn level" do
          log_msg = @logging.log("a warn level message", :level => :warn)
          assert_match /36;1/, log_msg, "not the warn level"
        end

        should "log at the error level" do
          log_msg = @logging.log("an error level message", :level => :error)
          assert_match /31;1/, log_msg, "not the error level"
        end

        should "log to levels through direct calls" do
          log_msg = @logging.debug("a direct debug level message")
          assert_match /33;1/, log_msg, "not a direct debug level"
          log_msg = @logging.info("a direct info level message")
          assert_match /32;1/, log_msg, "not a direct info level"
          log_msg = @logging.warn("a direct warn level message")
          assert_match /36;1/, log_msg, "not a direct warn level"
          log_msg = @logging.error("a direct error level message")
          assert_match /31;1/, log_msg, "not a direct error level"
          log_msg = @logging.debug("a debug direct level message attempting level override", :level => :warn)
          assert_match /33;1/, log_msg, "not the debug direct level"
        end

        should "default log at the debug level" do
          log_msg = @logging.log("a default message")
          assert_match /33;1/, log_msg, "not the debug level"
        end

        should "should not log an entry if no args are passed" do
          assert_equal nil, @logging.log()
        end

        should "log a msg with default options if only 1 arg is passed" do
          msg = "only 1 arg passed"
          assert_match %r{#{msg}}, @logging.log(msg), "msg not found"
        end

        should "log a named msg with default options if only 2 args are passed, no hash" do
          name = "A msg:"
          msg = "2 args, no hash passed"
          log_msg = @logging.log(name, msg)
          assert_match %r{#{name}}, log_msg, "name not found"
          assert_match %r{#{msg}}, log_msg, "msg not found"
        end

        should "log a msg with passed options if only 2 args are passed, last one hash" do
          msg = "2 args, opts empty prefix"
          log_msg = @logging.log(msg, {:prefix => ""})
          assert_match "\e[0m  \e[0;33;1m\e[0m\e[4;33;1m\e[0m", log_msg, "empty prefix, name not found"
          assert_match %r{#{msg}}, log_msg, "msg not found"
        end

        should "log a named msg with passed options" do
          name = "Another named msg:"
          msg = "3 args, opts empty prefix, opts no color"
          log_msg = @logging.log(name, msg, {:color => false, :prefix => ""})
          assert_match "\e[0m  \e[0;0m\e[0m\e[4;0m", log_msg, "name with no color not found"
          assert_match %r{#{msg}}, log_msg, "msg not found"
        end



      end
    end

  end
end
