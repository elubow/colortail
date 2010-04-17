module ColorTail

    class Application
        class << self
            def run!(*arguments)
               options = ColorTail::Options.new(arguments) 
    
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
                   # XXX TODO Read the config file
                   logger = ColorTail::Colorize.new()
    
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

    class Configuration
        def colorize(options)
            if options.class == Array
                options.each do |opt|
                    ColorTail::Colorize.add_color_matcher( opt )
                end
            else
                ColorTail::Colorize.add_color_matcher( options )
            end
        end
    end

    class Options < Hash
        attr_reader :opts, :orig_args

        def initialize(args)
            super()

            user_home = ENV['HOME']

            @orig_args = args.clone

            options = {}
            
            require 'optparse'
            @opts = OptionParser.new do |o|
                o.banner = "Usage: #{File.basename($0)} <file>"
            
                options[:group] = 'default'
                o.on( '-g', '--group', 'Specify the color grouping to use for these files' ) do |group|
                    options[:group] = group
                end

                o.separator ""
            
                options[:conf] = "#{user_home}/.colortailrc"
                o.on( '-c', '--conf <FILE>', 'Specify an alternate config file' ) do |file|
                    if File.exists?(file)
                        options[:conf] = file
                    else
                        options[:conf] = "#{user_home}/.colortailrc"
                    end
                end

                options[:help] = false
                o.on( '-h', '--help', 'Display this help screen' ) do
                    options[:help] = true
                    exit
                end
            end

            begin
                @opts.parse!(args)
                self[:files] = args
            rescue OptionParser::InvalidOption => e
                self[:invalid_argument] = e.message
            end
        end
    end

    class FileDoesNotExist < StandardError
    end

end
