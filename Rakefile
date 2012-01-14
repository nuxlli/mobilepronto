require 'bundler'
Bundler::GemHelper.install_tasks

gem 'minitest'
require 'minitest/unit'

desc 'Run all tests'
task :test do
  ENV['QUIET'] ||= 'true'

  $LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + '/test'))
  $LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))

  MiniTest::Unit.autorun

  test_files = Dir['test/**/*_test.rb']
  test_files.each { |f| require f }
end

desc 'Load the gem environment'
task :environment do
  require File.expand_path(File.dirname(__FILE__) + '/lib/mobilepronto.rb')
end

desc "Build the gem"
task :build do
  gem_name = 'mobilepronto'
  opers = Dir.glob('*.gem')
  opers = ["rm #{ opers.join(' ') }"] unless opers.empty?
  opers << ["gem build #{gem_name}.gemspec"]
  sh opers.join(" && ")
end

desc "Build and install the gem, removing old installation"
task :install => :build do
  gem_file = Dir.glob('*.gem').first
  gem_name = 'mobilepronto'
  if gem_file.nil?
    puts "could not install the gem"
  else
    sh "gem uninstall --ignore-dependencies --executables #{gem_name}; gem install #{ gem_file }"
  end
end

# To load rake tasks on lib/task folder
# load 'lib/tasks/task_sample.rake'

task :default => :test
