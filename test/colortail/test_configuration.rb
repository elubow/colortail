require 'helper'

module TestColortail

  class OptionsTest < Test::Unit::TestCase
    # No context name necessary since this is to redirect $stdout
    context "" do
      setup do
          ARGV.clear

          @stdout_orig = $stdout
          $stdout = StringIO.new
      end

      teardown do
          $stdout = @stdout_orig
      end

      should "return an options object with no arguments" do
          @opt = ColorTail::Options.new(ARGV)
          assert_equal @opt.class, ColorTail::Options
      end
      
      context "With a valid options class instance" do
        setup do
          ARGV.clear
          @opt = ColorTail::Options.new(ARGV)
        end
        
        should "have the group value set as default" do
          assert_equal @opt[:options][:group], "default"
        end

        should "have the help switch set to false" do
          assert_equal @opt[:options][:help], false
        end

        should "have the show list switch set to false" do
          assert_equal @opt[:options][:list], false
        end

        should "have an empty files array" do
          assert_equal @opt[:files].size, 0
        end

        should "have a possible config file to test for" do
          assert_not_nil @opt[:options][:conf]
        end
      end
      
      should "raise FileDoesNotExist error on non-existant config file" do
        ARGV.clear
        config_file = String.new
        ARGV.push("-c",config_file)
        assert_raise( ColorTail::FileDoesNotExist ) { @opt = ColorTail::Options.new(ARGV) }
      end
      
    end
  end


  class ConfigurationTest < Test::Unit::TestCase
    # No context name necessary since this is to redirect $stdout
    context "" do
      setup do
          ARGV.clear

          @stdout_orig = $stdout
          $stdout = StringIO.new
      end

      teardown do
          $stdout = @stdout_orig
      end

      
      should "raise a FileDoesNotExist error for non-existant file" do
          config_file = String.new
          assert_raise( ColorTail::FileDoesNotExist ) { @config = ColorTail::Configuration.new(config_file) }
      end
      
      context "With a valid configuration instance" do
        setup do
          @stderr_orig = $stderr
          $stderr = StringIO.new
          
          @config_file = File.join(File.dirname(__FILE__), '..', '..', 'examples', 'colortail.rb')
          
          @config = ColorTail::Configuration.new("#{@config_file}")
        end
        
        teardown do
          $stderr = @stderr_orig
        end
        
        should "be a valid configuration instance" do
          assert_equal @config.class, ColorTail::Configuration
        end
        
        should "fallback to 'default' grouping when a non-existent match_group is specified" do
          @match_group = @config.load_opts('doesNotExist')
          assert_match "No such group '", $stderr.string
          assert_equal @match_group, "'default' => []"
        end
        
        should "display match groups" do
          @match_group = @config.load_opts('default')
          @config.display_match_groups()
          assert_match "  * ", $stdout.string
        end
      end
      

    end
  end
  
end
