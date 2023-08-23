# frozen_string_literal: true

require_relative "lib/object_context_logger/version"

Gem::Specification.new do |spec|
  spec.name = "object_context_logger"
  spec.version = ObjectContextLogger::VERSION
  spec.authors = ["Daniel P Zepeda"]
  spec.email = ["daniel@zepeda.ws"]

  spec.summary = "Logging helper that prefixes the object context it was called from into the log message"
  spec.description = "Logging helper that prefixes the object context it was called from into the log message"
  spec.homepage = "https://github.com/duskhacker/object-context-logger"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
end
