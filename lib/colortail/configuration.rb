module ColorTail

    class Configuration
        def initialize(conf)
            @config_file = conf
            if File.exists?(conf)
                @config = File.read(conf)
            else
                raise FileDoesNotExist, "Config file #{@config_file} cannot be found."
            end
        end

        def colorit(group, groupings)
            if groupings.class == Hash
                if groupings.has_key?( group )
                    return groupings[group]
                else
                    raise ComplexRecord, "No such group '#{group}' in config file"
                end
            else
                raise ComplexRecord, "Config file syntax error"
            end
        end

        # Load everything from the config file here since the colorit() method
        # isn't available in the configuration object until after a new object
        # has been instantiated.
        def load_opts(group)
            colorset = []
            if File.exists?(@config_file)
                load @config_file
                colorset = self.colorit( group, Groupings )
            end
            return colorset
        end

        def display_match_groups()
            Groupings.each_key do |group|
                puts "  * #{group}"
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
                o.banner = "Usage: #{File.basename($0)} <file1> <file2> ..."
            
                options[:group] = 'default'
                o.on( '-g', '--group <group>', 'Specify the color grouping to use for these files' ) do |group|
                    options[:group] = group
                end

                options[:list] = false
                o.on( '-l', '--list', 'List all the available color groupings' ) do |group|
                    options[:list] = true
                end

                o.separator ""
            
                options[:conf] = "#{user_home}/.colortailrc"
                o.on( '-c', '--conf <file>', 'Specify an alternate config file' ) do |file|
                    if File.exists?(file)
                        options[:conf] = file
                    else
                        raise FileDoesNotExist, "Config file #{file} cannot be found."
                    end
                end

                options[:help] = false
                o.on_tail( '-h', '--help', 'Display this help screen' ) do
                    options[:help] = true
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
