require 'useful/ruby_helpers/logger'
require 'log4r'

module RubyHelpers

  class LoggingNone
    include Useful::RubyHelpers::Logger
  end

  class LoggingBad
    include Useful::RubyHelpers::Logger

    @@logger = Log4r::Logger.new("LoggerCorrect")
    @@logger.add(Log4r::StdoutOutputter.new('console', {
      :formatter => Log4r::PatternFormatter.new(:pattern => "%m")
    }))

    def self.logger
      # method returning something
      # without a log4r interface
      []
    end
  end

  class LoggingGood
    include Useful::RubyHelpers::Logger

    @@logger = Log4r::Logger.new("LoggerCorrect")
    @@logger.add(Log4r::StdoutOutputter.new('console', {
      :formatter => Log4r::PatternFormatter.new(:pattern => "%m")
    }))

    def self.logger
      @@logger
    end
  end

end
