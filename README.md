# Diuitauth

A simple Ruby gem library for helping you to get Diuit API session easier.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'diuitauth'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install diuitauth

## Usage

```ruby
require 'diuitauth'

# Can user file reader
private_key = "-----BEGIN RSA PRIVATE KEY-----
  -----END RSA PRIVATE KEY-----"

exp = Time.now.utc.to_i + 4 * 3600

client = {
  :app_id => "Your appId",
  :app_key => "Your appKey",
  :key_id => "Your appKeyId",
  :private_key => "#{private_key}",
  :exp => "#{exp}",
  :platform => "ios_sandbox", # ['gcm', 'ios_sandbox', 'ios_production']
  :user_serial => "Your user serial",
  :device_id => "Your device id"
}

return Diuitauth::Login.get_session_token client.to_json
```

###  More

Please refer [Diuit Messaging API](http://api2.diuit.com/).
