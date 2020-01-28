# frozen_string_literal: true

require "active_support/tagged_logging"

module Moleculer
  ##
  # Implements a tagged logger
  module Logger
    ##
    # Tagged logger formatter
    class Formatter < ::Logger::Formatter
      Format = "%s, [%s#%d] [%s] %5s -- %s: %s\n"

      def initialize(*tags)
        super()
        @tags = tags
      end

      def call(severity, time, progname, msg)
        format(Format, severity[0..0], format_datetime(time), $PROCESS_ID, @tags.join("|"), severity, progname, msg2str(msg))
      end
    end

    ##
    # Gets a tagged logger instance
    def get_logger(*tags)
      unless @logger
        @logger     ||= ::Logger.new(log_file)
        @logger.level = log_level
      end
      new_logger           = @logger.dup
      new_logger.formatter = Formatter.new(*tags)
      new_logger
    end

    private

    def log_file
      (@options && @options[:log_file]) || ENV["MOLECULER_LOG_FILE"] || STDOUT
    end

    def log_level
      (@options && @options[:log_level]) || ENV["MOLECULER_LOG_LEVEL"] || "debug"
    end

  end
end
