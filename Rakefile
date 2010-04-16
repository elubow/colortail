require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "colortail"
    gem.executables = "colortail"
    gem.summary = "Tail a file and color lines based on regular expressions within that line"
    gem.description = "Tail a file and color lines based on regular expressions within that line"
    gem.email = "eric@lubow.org"
    gem.homepage = "http://codaset.com/elubow/color-tail"
    gem.authors = ["Eric Lubow"]
    gem.add_dependency 'file-tail'
    gem.add_development_dependency "thoughtbot-shoulda", ">= 0"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "colortail #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
