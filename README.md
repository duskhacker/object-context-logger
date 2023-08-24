# ObjectContextLogger

ObjectContextLogger is as simple utility that automatically prepends a given log message with the context that it was 
called from.

This utility was born out of the frustration of reading logs to debug a problem, finding a useful message,
then wishing I knew which instance of a class/object or other context it was called from.
Being lazy, instead of trying to remember to always include that 
context in the log message, I wrote this little bit of code. 

## Installation

### Bundler 

    gem 'object_context_logger', '~> 0.1.0'

### Gem install

    $ gem install object_context_logger

## Configuration

### Rails

If you'll be using this in a Rails app, then you can generate the configuration initializer with this:

    $ rails generate object_context_logger_initializer

### Manually

If you'll be using this outside of a Rails app, you'll need to proved the configuration manually: 

```
      ObjectContextLogger.configure do |config|
        # config.logger = Rails.logger # must respond to logger methods like :info, :debug
        # config.default_log_method = :info 
        # config.default_object_identifier_method = :to_gid  
        # config.log_to_stdout = false 
      end

```

### Configuration Items 

* `logger` - The only required setting, provide a logger object that must at least respond to `:info`
* `default_log_method` - This is the method sent to the logger object to register a log. 
* `default_object_identifier_method` - By default, ObjectContextLogger uses [GlobalID](https://github.com/rails/globalid),
 if you are outside of a Rails project or dealing with objects that do not respond to `to_gid` by default, you'll
 want to use a different default identifier method, like `to_s`, appropriately defined on the objects you are logging
 from. 
* `log_to_stdout` - Sometimes useful when debugging scripts.  

## Usage

The whole idea of this utility is to make logging with context simple: 

### In the context of an instance of User (id 1)

    ctx_log "Your very informative log message"
    #=> gid://gem-host/User/1: Your very informative message

If you want to use a particular logger facility, you can specify it: 

    ctx_log "Your very informative log message", :debug
    #=> gid://gem-host/User/1: Your very informative message

If the object/class you are logging from requires some special identifier, you can specify it: 

    ctx_log "Your very informative log message", object_identifier: "some string or method call"
    #=> some string or method call: Your very informative log message

### In the context of a class User 

    ctx_log "Your very informative log message"
    #=> User: Your very informative message

Finally, there is a helper method to use if you want to add context to exceptions: 

    raise "#{ctx_log_prefix}: Your very informative exception message"
    #=> User: Your very informative exception message

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. 
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/duskhacker/object-context-logger.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
