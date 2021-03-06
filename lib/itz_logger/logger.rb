
require_relative "./log_terminal"
require_relative "./log_file"
require_relative "./log_strategy"

require 'securerandom'

module ItzLogger

  class Logger

    @log_strategy = nil
    @log_id = nil

    def initialize(options = {})

      log_level = options.fetch(:log_level, ItzLogger::MessageType::INFO)
      log_strategy = options.fetch(:log_strategy, ItzLogger::LogStrategy::LOG_TERMINAL)
      log_file = options.fetch(:log_file, "./log/logfile.log")
      @log_id = SecureRandom.hex(4)

      @log_strategy =
        case log_strategy
        when ItzLogger::LogStrategy::LOG_TERMINAL
          ItzLogger::LogTerminal.new(log_level, @log_id)
        when ItzLogger::LogStrategy::LOG_FILE
          ItzLogger::LogFile.new(log_level, log_file, @log_id)
        end
    end

    def write(log_level, message)
      @log_strategy.write(log_level, message)
    end

    def info(message)
      @log_strategy.write(ItzLogger::MessageType::INFO, message)
    end

    def warn(message)
      @log_strategy.write(ItzLogger::MessageType::WARN, message)
    end

    def debug(message)
      @log_strategy.write(ItzLogger::MessageType::DEBUG, message)
    end

    def verbose(message)
      @log_strategy.write(ItzLogger::MessageType::VERBOSE, message)
    end

    def log_level=(log_level)
      @log_strategy.log_level = log_level
    end

    def log_level
      @log_strategy.log_level
    end

    def id
      @log_id
    end

  end
end
