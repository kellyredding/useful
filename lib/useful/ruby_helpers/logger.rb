module Useful; end
module Useful::RubyHelpers; end

require 'useful/ruby_extensions/object'

module Useful::RubyHelpers::Logger

  module ClassMethods
    def benchmark(*args, &block)
      require 'benchmark'
      name, msg, opts = handle_log_args(args)
      result = nil
      ms = Benchmark.measure { result = block.call }.real
      name += ' ' unless name.empty?
      name += '(%.1fms)' % [ms*1000]
      log(name, msg, opts)
      result
    end

    def log(*args)
      name, msg, opts = handle_log_args(args)
      opts[:level] ||= 'debug'
      opts[:color] = true if opts[:color].nil?
      unless logger.respond_to?(opts[:level].to_s)
        raise Exception, "no '#{opts[:level].to_s.upcase}' logger provided"
      end
      if name.empty? && msg.empty?
        nil
      else
        returning formatted_log_msg(name, msg, opts) do |log_msg|
          logger.send(opts[:level].to_s, log_msg)
        end
      end
    end

    [:debug, :info, :warn, :error].each do |level|
      define_method(level) do |*args|
        if args.last.kind_of?(::Hash)
          args.last[:level] = level
        else
          args << {:level => level}
        end
        log(*args)
      end
    end

    private

    def logger
      raise Exception, "to use these logging features, override the self.logger method and provide a log4r-style logger"
    end

    def formatted_log_msg(name, msg, opts)
      opts[:prefix] ||= case opts[:level].to_s
      when 'info'
        "*"  # green
      when 'warn'
        "~"  # cyan
      when 'error'
        "!"  # red
      else # debug
        "-"
      end
      color_level = opts[:color] ? opts[:level].to_s : 'none'
      color = case color_level
      when 'debug'
        "33;1"  # yellow
      when 'info'
        "32;1"  # green
      when 'warn'
        "36;1"  # cyan
      when 'error'
        "31;1"  # red
      else
        # white
        "0"
      end
      color_reg = "0;#{color}"
      color_underlined = "4;#{color}"
      "\e[0m  \e[#{color_reg}m#{opts[:prefix]}\e[0m#{opts[:prefix].empty? ? '' : '  '}\e[#{color_underlined}m#{name}\e[0m#{name.empty? ? '' : '  '}#{msg}"
    end

    def handle_log_args(args)
      case (the_args = args.flatten).length
      when 3
        the_args
      when 2
        if the_args.last.kind_of?(::Hash)
          ["", the_args.first, the_args.last]
        else
          [the_args.first, the_args.last, {}]
        end
      when 0
        ["", "", {}]
      else
        ["", the_args.first, {}]
      end
    end
  end



  module InstanceMethods
    def benchmark(*args, &block)
      self.class.send(:benchmark, *args, &block)
    end

    def log(*args)
      self.class.send(:log, *args)
    end

    [:debug, :info, :warn, :error].each do |level|
      define_method(level) do |*args|
        self.class.send(level, *args)
      end
    end
  end



  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end

end
