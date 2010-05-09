module ColorTail

    class Application
        class << self
            def version
                version = File.read("#{File.join(File.dirname(__FILE__), '..')}/../VERSION").chomp!
                "#{File.basename($0)} v#{version}"
            end
            
            def run!(*arguments)
               require 'fcntl'
                
               opt = ColorTail::Options.new(arguments) 
               files = opt[:files]
               options = opt[:options]
    
               # Deal with any/all options issues
               if opt[:invalid_argument]
                   $stderr.puts opt[:invalid_argument]
                   options[:help] = true
               end
    
               # Show the help menu if desired
               if options[:help]
                   $stderr.puts version()
                   $stderr.puts opt.opts
                   return 1
               end
               
               # Show the version
               if options[:version]
                   $stderr.puts version()
                   return 1
               end

   
               # The meat of the program
               begin
                   # Read the config file if it exists
                   if File.exists?(options[:conf])
                       config = ColorTail::Configuration.new(options[:conf])
                       @match_group = config.load_opts(options[:group])
                   else
                       # Create this to ensure we always have a value for this array
                       @match_group = Array.new
                       @match_group.push( 'default' => [] )
                   end

                   # Display the list of available groups and exit
                   if options[:list]
                       puts "The following match groups are available through your config files:"
                       if config
                           config.display_match_groups()
                       else
                           puts "  * default"
                       end
                       return 1
                   end
                   
                   # Create the logging object
                   logger = ColorTail::Colorize.new()

                   # Add the color match array if we aren't using the default
                   if @match_group.class == Array
                       @match_group.each do |matcher|
                           logger.add_color_matcher( matcher )
                       end
                   else
                       logger.add_color_matcher( @match_group )
                   end
                   
                   # Create an empty array of threads
                   threads = Array.new
                   
                   # Set $stdin to be non-blocking
                   $stdin.fcntl(Fcntl::F_SETFL,Fcntl::O_NONBLOCK)
                   
                   begin
                       threads[0] = Thread.new {
                           STDIN.fcntl(Fcntl::F_SETFL,Fcntl::O_NONBLOCK)
                           begin
                               $stdin.each_line do |line|
                                   logger.log( nil, line )
                               end
                           rescue Errno::EAGAIN
                               # Remove this thread since we won't be reading from $stdin
                               threads.delete(0)
                           end
                       }.run
                       
                       # Check to see if there are files in the files array
                       if files.size > 0
                           # Before we go any further, check for existance of files
                           @files_exist = false
                           files.each do |file|
                               # Check for individual files and ignore file if doesn't exist
                               if File.exists?(file)
                                   @files_exist = true
                               else
                                   $stderr.puts("#{file} does not exist, skipping...")
                                   files.delete(file)
                               end
                           end
                           
                           # If we have no files, tell them and show the help
                           if !@files_exist and (threads.class == Array.class and threads.size <= 2)
                               $stderr.puts "Please check to make sure the files exist ..."
                               $stderr.puts opt.opts
                               return 1
                           end
                           
                           # Create a thread for each file
                           files.each do |file|
                               threads.push Thread.new {
                                   tailer = ColorTail::TailFile.new( file )

                                   # First display the last 10 lines of each file in ARGV
                                   tailer.interval = 10
                                   tailer.backward( 10 )

                                   # Tail the file and show new lines
                                   tailer.tail { |line|  logger.log( file, line ) }
                               }
                               threads[files.index(file)].run
                           end
                       end
                       
                   end

                   # Let the threads do their real work
                   threads.each do |thread|
                       thread.join
                   end

               # If we get a CTRL-C, catch it (rescue) and send it for cleanup
               rescue Interrupt
                   thread_cleanup(threads) if defined? threads
               rescue NoInputError
                   $stderr.puts "Please enter a file to tail..."
                   $stderr.puts opt.opts
                   return 1
               end

               # We should never make it here, but just in case...
               return 0
            end

            def thread_cleanup(threads)
                if threads.class == Array.class and threads.size > 0
                    threads.each do |thread|
                        thread.kill
                    end
                end
                $stderr.puts "Terminating..."
                exit
            end
        end
    end

    class Cleanup
    end


    class NoInputError < StandardError
    end

    class FileDoesNotExist < StandardError
    end

end
