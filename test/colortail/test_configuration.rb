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

    end
  end
  
end
