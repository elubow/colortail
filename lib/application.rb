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
                   config = ColorTail::Configuration.new(options[:conf])
                   match_group = config.load_opts(options[:group])

                   logger = ColorTail::Colorize.new()

                   # Add the color match array
                   if match_group.class == Array
                       match_group.each do |matcher|
                           logger.add_color_matcher( matcher )
                       end
                   else
                       logger.add_color_matcher( match_group )
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
