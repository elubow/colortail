module ColorTail

    class Configuration
        def initialize(conf)
            if File.exists?(conf)
                require conf
            else
                raise FileDoesNotExist, "Config file #{file} cannot be found."
            end
            puts "Config File output: #{conf}\n"
        end

        def colorit(groupings)
            if groupings.class == Hash
                groupings.keys do |group|
                    puts "Group Key ID: #{group}\n"
                    ColorTail::Colorize.add_color_matcher( group )
                end
            else
                raise 
            end
        end
    end

    class ComplexRecord < StandardError
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
                        raise FileDoesNotExist, "Config file #{file} cannot be found."
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
                self[:options] = options
            rescue OptionParser::InvalidOption => e
                self[:invalid_argument] = e.message
            end
        end
    end

end
