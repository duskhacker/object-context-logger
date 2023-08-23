require_relative "../test_helper"

class TestContext
  class << self
    def run
      ctx_log("class run")
    end

    def use_ctx_log_prefix
      ctx_log_prefix
    end
  end

  def run
    ctx_log("run")
  end

  def run_logging_to_debug
    ctx_log("run", :debug)
  end

  def run_logging_to_other_method
    ctx_log("run", :other_method)
  end

  def to_s
    "test_context"
  end
end

class TestContextWithGid
  def run
    ctx_log("run")
  end

  def to_gid
    "gid://object-context-logger/TestContextWithGid/1"
  end

  def use_ctx_log_prefix
    ctx_log_prefix
  end
end

class TestLogger

  attr_reader :buffer

  def initialize
    @buffer = StringIO.new
  end

  def info(data)
    buffer << data
  end

  def debug(data)
    buffer << "debug: #{data}"
  end

  def other_method(data)
    buffer << "other_method: #{data}"
  end
end

class TestObjectContextLogger < Minitest::Test

  attr_reader :logger

  def setup
    @logger = TestLogger.new
    ObjectContextLogger.configure do |config|
      config.logger = logger
      config.default_object_identifier_method = :to_gid
      config.default_log_method = :info
    end
  end

  def test_that_it_has_a_version_number
    refute_nil ::ObjectContextLogger::VERSION
  end

  def test_logs_with_class_context
    TestContext.new.run
    assert_equal "TestContext: run", logger.buffer.string
  end

  def test_logs_with_gid
    TestContextWithGid.new.run
    assert_equal "gid://object-context-logger/TestContextWithGid/1: run", logger.buffer.string
  end

  def test_logs_with_configured_identifier_method
    ObjectContextLogger.configure do |config|
      config.default_object_identifier_method = :to_s
    end

    TestContext.new.run
    assert_equal "test_context: run", logger.buffer.string
  end

  def test_logs_in_class_method_context
    TestContext.run
    assert_equal "TestContext: class run", logger.buffer.string
  end

  def test_logs_using_configured_method
    ObjectContextLogger.configure do |config|
      config.default_log_method = :debug
    end

    TestContext.new.run_logging_to_debug
    assert_equal "debug: TestContext: run", logger.buffer.string
  end

  def test_logs_using_given_method
    TestContext.new.run_logging_to_other_method
    assert_equal "other_method: TestContext: run", logger.buffer.string
  end

  def test_raises_exception_if_logger_not_configured
    ObjectContextLogger.configure do |config|
      config.logger = nil
    end
    error = assert_raises(RuntimeError) {
      TestContext.new.run
    }
    assert_equal "ObjectContextLogger: logger is not configured, use ObjectContextLogger.configure to set it", error.message
  end

  def test_ctx_log_prefix
    assert_equal "TestContext", TestContext.use_ctx_log_prefix
    assert_equal "gid://object-context-logger/TestContextWithGid/1", TestContextWithGid.new.use_ctx_log_prefix
  end
end
