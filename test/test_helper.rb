# encoding: UTF-8

# Load do ambiente da gem
require File.expand_path(File.dirname(__FILE__) + '/../lib/mobilepronto.rb')

gem 'minitest'
require 'minitest/autorun'
require 'webmock/minitest'
require 'minitest/pride'

begin
  require 'ruby-debug'
rescue Exception => e; end

