# What is it?

A Ruby interface to the [MobilePronto](http://www.mobilepronto.org/) SMS gateway API.
Please note: this gem is a proxy to MobiePronto SMS gateway, to use it you should get your credentials with the service of [MobilePronto](http://www.mobilepronto.org/), not responsible at any time by the service offered by [MobilePronto](http://www.mobilepronto.org/).

# Installation

Download [the latest version of gem](http://rubygems.org/gems/mobilepronto) or install using RubyGems.

```shell
$ sudo gem install mobilepronto
```

## MobilePronto on GitHub

```shell
$ git clone git://github.com/nuxlli/mobilepronto.git
```

# Basic Usage

To use this gem, you will need sign up for an account at the [MobilePronto](http://www.mobilepronto.org/) website. 
Once you are registered and logged into your account centre, you should add 
an HTTP API connection to your account. This will give you your CREDENCIAL.

## Demonstration
### EnviaSMS

```ruby
require 'mobilepronto'

# Configure default values
MobilePronto.configure do |config|
  # Default api url
  # config.url_api = "http://www.mpgateway.com/v_2_00/smspush/enviasms.aspx"
  
  config.credential   = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
  config.project_name = "MYPROJECT"
  config.send_project = true
end

sms = {
  :mobile    => 552199999999,
  :user_name => "MYUSER",
  :message   => "Mensagem de test"
}

# Using blocks to analyze the result
MobilePronto.send_sms(sms) do |result|
  result.on(:ok) { puts "Mensagem sendend..." }
  result.on(1..999) { puts "Ops: #{result.error.message}"}
end

# Or begin/rescue
begin
  MobilePronto.send_sms(sms)
rescue MobilePronto::SendError => e
  puts "Ops: #{e.message}"
end

```

# References

http://www.mobilepronto.info/samples/en-US/1205-httpget-php-v_2_00.pdf

# License

MobilePronto is licensed under the [BSD License](http://opensource.org/licenses/BSD-2-Clause).

See LICENSE file for details.

