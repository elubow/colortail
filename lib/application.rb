module ColorTail

    class Application
        class << self
            def run!(*arguments)
               opt = ColorTail::Options.new(arguments) 
               files = opt[:files]
               options = opt[:options]
    
               # Deal with any/all options issues
               if options[:invalid_argument]
                   $stderr.puts options[:invalid_argument]
                   options[:help] = true
               end
    
               if options[:help]
                   $stderr.puts options.opts
                   return 1
               end
    
               begin
                   # Read the config file
                   puts "Config: #{options[:conf]}\n"
                   config = ColorTail::Configuration.new(options[:conf])

                   logger = ColorTail::Colorize.new(config)
    
                   files = []
    
                   options[:files].each do |file|
                       if File.exists?(file)
                           files.push(file)
                       end
                   end
    
                   # XXX TODO Just tail the first file
                   tailer = ColorTail::TailFile.new( files[0] )
                   tailer.interval = 10
                   tailer.backward( 10 )
                   tailer.tail { |line|  logger.log( files[0], line ) }
               end
            end
        end
    end


    class FileDoesNotExist < StandardError
    end

end
