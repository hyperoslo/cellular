# Cellular

[![Gem Version](https://img.shields.io/gem/v/cellular.svg)](https://rubygems.org/gems/cellular)
[![Build Status](https://img.shields.io/travis/hyperoslo/cellular.svg)](https://travis-ci.org/hyperoslo/cellular)
[![Dependency Status](https://img.shields.io/gemnasium/hyperoslo/cellular.svg)](https://gemnasium.com/hyperoslo/cellular)
[![Code Climate](https://img.shields.io/codeclimate/github/hyperoslo/cellular.svg)](https://codeclimate.com/github/hyperoslo/cellular)
[![Coverage Status](https://img.shields.io/coveralls/hyperoslo/cellular.svg)](https://coveralls.io/r/hyperoslo/cellular)

Sending and receiving SMSs with Ruby through pluggable backends.

**Supported Ruby versions: 1.9.3 or higher**

Licensed under the **MIT** license, see LICENSE for more information.


## Installation

Add this line to your application's Gemfile:

    gem 'cellular'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cellular


## Usage

### Configuration

```ruby
Cellular.configure do |config|
  config.username = 'username'
  config.password = 'password'
  config.backend  = Cellular::Backends::Sendega
  config.sender = 'Default custom sender'
end
```


### Available Backends

* [CoolSMS](http://coolsms.com/)
* [Sendega](http://sendega.com/)
* Log


### Sending SMSs

The options supported may differ between backends.

```ruby
sms = Cellular::SMS.new(
  recipient: '47xxxxxxxx',
  sender: 'Custom sender',
  message: 'This is an SMS message'
)

sms.deliver
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create pull request


## Credits

Hyper made this. We're a digital communications agency with a passion for good code,
and if you're using this library we probably want to hire you.
