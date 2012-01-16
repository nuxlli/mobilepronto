# encoding: UTF-8

begin
  require "step-up"
rescue Exception => e; end

class MobilePronto
  module VERSION #:nodoc:
    pwd = ::File.expand_path(::File.dirname(__FILE__))
    version = nil
    version = $1 if ::File.join(pwd, '../..') =~ /\/mobilepronto-(\d[\w\.]+)/
    version_file = ::File.join(pwd, '../../GEM_VERSION')
    version = File.read(version_file) if version.nil? && ::File.exists?(version_file)
    if version.nil? && ::File.exists?(::File.join(pwd, '/../../.git'))
      version = ::StepUp::Driver::Git.new.last_version_tag("HEAD", true) rescue "v0.0.0+0"
      ::File.open(version_file, "w"){ |f| f.write version }
    end

    STRING = version.gsub(/^v?([^\+]+)\+?\d*$/, '\1')
    MAJOR, MINOR, PATCH, TINY = STRING.scan(/\d+/)

    def self.to_s
      STRING
    end
  end
end
