require 'helper'

module TestColortail

  class ColortailTest < Test::Unit::TestCase
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


      context "With no options or files" do
          setup do
              ARGV.clear
          end
          
          should "show the help menu" do
          end
      end

      context "With no files and -h option" do
          setup do
              ARGV.clear
              ARGV.push("-h")
          end
          
          should "show the help menu" do
          end
      end

      context "With 1 file" do
          setup do
              ARGV.clear
              @tmp_root = File.dirname(__FILE__) + "/../tmp"

          end

          teardown do
              FileUtils.rm_rf @tmp_root
          end
      end

      context "With valid logger class" do
        setup do
          @logger = ColorTail::Colorize.new()
        end
        
        should "be a valid logger class" do
            @class = @logger.class
            assert_equal @class, ColorTail::Colorize
        end

        should "show a line with no prefix" do
            @logger.show('My test line', nil)
            assert_equal $stdout.string, "My test line\n"
        end

        should "show a line with 'filename:' as a prefix" do
            @logger.show('My test line', 'filename:')
            assert_equal $stdout.string, "filename:My test line\n"
        end
        
        should "add nothing to the color matchers class variable with an empty match group" do
            match_group = Array.new
            assert_equal match_group, @logger.color_matchers
            match_group.push( 'default' => [] )
            @logger.add_color_matcher( 'default' => [] )
            assert_equal match_group, @logger.color_matchers
        end
        
        context "and an empty match group" do
          setup do
            @logger.add_color_matcher( 'default' => [] )
          end

          should "say 'My test line' with no prefix" do
            @logger.log('testfile','My test line')
            assert_equal $stdout.string, "\e[0mMy test line\e[0m\n"
          end

          should "say 'My test line' with 'testfile: ' as the prefix" do
            @logger.log('testfile','My test line','testfile: ')
            assert_equal $stdout.string, "\e[0mtestfile:\e[0m\e[0mMy test line\e[0m\n"
          end
        end
      end

    end
  end
  
end