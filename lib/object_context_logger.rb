require_relative "object_context_logger/version"

module ObjectContextLogger
  class Error < StandardError; end

  def self.included(base)
    base.extend ClassMethods
  end

  def ctx_log(message, method = :info, object_identifier: nil)
    self.class.ctx_log(
      message,
      method,
      object_identifier: object_identifier || obj_id
    )
  end

  def ctx_log_prefix(object_identifier = nil)
    self.class.ctx_log_prefix(object_identifier || obj_id)
  end

  module ClassMethods
    def ctx_log(message, method = nil, object_identifier: nil)
      config = ObjectContextLogger.configuration
      m = "#{ctx_log_prefix(object_identifier)}: #{message}"
      puts m if config.log_to_stdout
      if config.logger.nil? || config.logger == ""
        raise "ObjectContextLogger: logger is not configured, use ObjectContextLogger.configure to set it"
      end
      config.logger.send(method || config.default_log_method, m)
    end

    def ctx_log_prefix(object_identifier = nil)
      return object_identifier unless object_identifier.nil? || object_identifier.to_s == ""
      "#{self.class == Class ? self : self.class}"
    end
  end

  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end
  end

  class Configuration
    attr_accessor :logger, :log_to_stdout, :default_object_identifier_method, :default_log_method

    def initialize
      @default_object_identifier_method = :to_gid
      @default_log_method = :info
    end
  end

  private

  def obj_id
    send(ObjectContextLogger.configuration.default_object_identifier_method.to_s) rescue nil
  end
end

include ObjectContextLogger
