require 'rubygems'
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'colortail'

class Test::Unit::TestCase
  
  class TestNotImplemented < StandardError
  end
  
end
