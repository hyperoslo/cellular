# Cellular

[![Gem Version](https://img.shields.io/gem/v/cellular.svg?style=flat)](https://rubygems.org/gems/cellular)
[![Build Status](https://img.shields.io/travis/hyperoslo/cellular.svg?style=flat)](https://travis-ci.org/hyperoslo/cellular)
[![Dependency Status](https://img.shields.io/gemnasium/hyperoslo/cellular.svg?style=flat)](https://gemnasium.com/hyperoslo/cellular)
[![Code Climate](https://img.shields.io/codeclimate/github/hyperoslo/cellular.svg?style=flat)](https://codeclimate.com/github/hyperoslo/cellular)
[![Coverage Status](https://img.shields.io/coveralls/hyperoslo/cellular.svg?style=flat)](https://coveralls.io/r/hyperoslo/cellular)

Sending and receiving SMSs with Ruby through pluggable backends.

**Supported Ruby versions: 2.0.0 or higher**

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
  config.country_code = 'NO'
end
```


### Available Backends

* [CoolSMS](http://coolsms.com/)
* [Sendega](http://sendega.com/)
* Log (logs to `$stdout`)
* Test (adds messages to `Cellular.deliveries`)


### Sending SMSs

The options supported may differ between backends.

```ruby
sms = Cellular::SMS.new(
  recipient: '47xxxxxxxx',
  sender: 'Custom sender',
  message: 'This is an SMS message',
  price: 0,
  country_code: 'NO' # defaults to Cellular.config.country_code
)

sms.deliver
```

You can also use Sidekiq to send texts, which is great if you're in a Rails app
and are concerned that it might time out or something. Actually, if you have
Sidekiq at your disposal, it's a great idea anyway! To use it, just call
`deliver_later` instead of `deliver` on the SMS object:

```ruby
sms = Cellular::SMS.new(
  recipient: '47xxxxxxxx',
  sender: 'Custom sender',
  message: 'This is an SMS message'
)

sms.deliver_later
```

This will create a Sidekiq job for you on the **cellular** queue, so make sure
that Sidekiq is processing that queue.

[sidekiq]: http://sidekiq.org

#### Schedule SMSs

Using Sidekiq, Cellular allows you to schedule the time when an SMS will be sent.
Just call `deliver_at(timestamp)` on the SMS object:

```ruby
sms = Cellular::SMS.new(
  recipient: '47xxxxxxxx',
  sender: 'Custom sender',
  message: 'This is an SMS message'
)

sms.deliver_at 3.hours.from_now
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
