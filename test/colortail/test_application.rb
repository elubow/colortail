require 'helper'

module TestColortail

  class ApplicationTest < Test::Unit::TestCase
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

      should "" do
        assert 1
      end
#     should "kill all threads" do
#       threads = Array.new
#       threads.push(Thread.new { sleep }, Thread.new { sleep })
#       assert_equal 2, threads.size
#       assert_equal "sleep", threads[0].status
#       assert_equal "sleep", threads[1].status
#       thread_cleanup(threads)
#       assert_equal false, threads[0].status
#       assert_equal false, threads[1].status
#     end
    end
  end
  
end
