class ObjectContextLoggerInitializerGenerator < Rails::Generators::Base
  def create_initializer_file
    create_file "config/initializers/object_context_logger.rb", <<~RUBY
      ObjectContextLogger.configure do |config|
        # config.logger = Rails.logger # must respond to logger methods like :info, :debug
        # config.default_log_method = :info 
        # config.default_object_identifier_method = :to_gid  
        # config.log_to_stdout = false 
      end
    RUBY
  end
end
