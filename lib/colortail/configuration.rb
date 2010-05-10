module ColorTail

    class Configuration
        def initialize(conf)
            @config_file = conf
            if File.exists?(conf)
                load @config_file
            else
                raise FileDoesNotExist, "Config file #{@config_file} cannot be found."
            end
        end

        def colorit(group)
            if Groupings.class == Hash
                Groupings["default"] = [] unless Groupings.has_key?('default')
                if Groupings.has_key?( group )
                    return Groupings[group]
                else
                    $stderr.puts "No such group '#{group}', falling back to default."
                    return "'default' => []"
                end
            else
                raise ComplexRecord, "Config file syntax error"
            end
        end

        # Load everything from the config file here since the colorit() method
        # isn't available in the configuration object until after a new object
        # has been instantiated.
        def load_opts(group)
            colorset = Array.new
            colorset = self.colorit( group )
            return colorset
        end

        def display_match_groups()
            Groupings.each_key do |group|
                puts "  * #{group}"
            end
        end
        
        def group_exists?(key)
            Groupings.has_key?(key) ? true : false
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
                
                options[:filename_prefix] = false
                o.on( '-F', '--filename_prefix', 'Prefix each colored line with it\'s filename') do
                    options[:filename_prefix] = true
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
                
                o.on('-V', '--version', "Display version information") do
                    options[:version] = true
                end

                options[:help] = false
                o.on( '-h', '--help', 'Display this help screen' ) do
                    options[:help] = true
                end
                
                o.separator ""
                o.separator "Examples:"
                o.separator "  Tail messages and mail log through STDIN with syslog group:"
                o.separator "    cat /var/log/maillog | #{File.basename($0)} -g syslog /var/log/messages"

                o.separator "  Tail messages with syslog group and maillog with mail group:"
                o.separator "    #{File.basename($0)} /var/log/messages#syslog /var/log/messages#mail"

                o.separator "  Tail messages with syslog group and maillog with mail group with line prefix:"
                o.separator "    #{File.basename($0)} -F /var/log/messages#syslog /var/log/messages#mail"
            end

            begin
                @opts.parse!(args)
                self[:files] = args
                self[:options] = options
            rescue OptionParser::InvalidOption => e
                self[:invalid_argument] = e.message
                @opts.parse(args, flags={ :delete_invalid_opts => true })
                self[:files] = args
                self[:options] = options
            end
        end
    end

end
