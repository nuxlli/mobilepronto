# encoding: UTF-8
$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__))

# Dependencies
require "rubygems"
require "net/http"
require "uri"

require File.dirname(__FILE__) + '/mobilepronto/version'
require File.dirname(__FILE__) + '/mobilepronto/errors'
require File.dirname(__FILE__) + '/mobilepronto/basic'

class MobilePronto
  extend Basic
  # autoload :AClass , "migrator/a_class"
end

# Default configuration
MobilePronto.configure do |config|
  config.url_api      = "http://www.mpgateway.com/v_2_00/smspush/enviasms.aspx"
  config.send_project = false
end
