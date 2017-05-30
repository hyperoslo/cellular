# Cellular

[![Gem Version](https://img.shields.io/gem/v/cellular.svg?style=flat)](https://rubygems.org/gems/cellular)
[![Build Status](https://img.shields.io/travis/hyperoslo/cellular.svg?style=flat)](https://travis-ci.org/hyperoslo/cellular)
[![Dependency Status](https://img.shields.io/gemnasium/hyperoslo/cellular.svg?style=flat)](https://gemnasium.com/hyperoslo/cellular)
[![Code Climate](https://img.shields.io/codeclimate/github/hyperoslo/cellular.svg?style=flat)](https://codeclimate.com/github/hyperoslo/cellular)

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
  config.backend = Cellular::Backends::Sendega
  config.sender = 'Default custom sender'
  config.country_code = 'NO'
end
```

### Available Backends

* [Cellular::Backends::CoolSMS](http://coolsms.com/)
* [Cellular::Backends::Sendega](http://sendega.com/)
* [Cellular::Backends::Twilio](http://twilio.com/)
* [Cellular::Backends::LinkMobility](https://www.linkmobility.com)
* Log (logs to `$stdout`)
* Test (adds messages to `Cellular.deliveries`)


### Sending SMSs

The options supported may differ between backends.

```ruby
sms = Cellular::SMS.new(
  recipient: '+47xxxxxxxx', # Valid international format
  sender: '+370xxxxxxxx',
  message: 'This is an SMS message',
  price: 0,
  country_code: 'NO' # defaults to Cellular.config.country_code
)

sms.deliver
```
For use with multiple recipients in one request use:

```ruby
sms = Cellular::SMS.new(
  recipients: ['+47xxxxxxx1','+47xxxxxxx2','+47xxxxxxx3'],
  sender: '+370xxxxxxxx',
  message: 'This is an SMS message',
  price: 0,
  country_code: 'NO' # defaults to Cellular.config.country_code
)

sms.deliver
```

## Troubleshooting

If you are using Twilio as a backend, please make sure you add or (port)[https://www.twilio.com/help/faq/porting] a phone number to your account so, that you can use that as a sender option. You won't be able to send messages from any phone number unless you port it to Twilio.

Also, make sure phone numbers are in valid international format:
[`+47xxxxxx`, `+370xxxxx`]

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b feature/my-new-feature`)
3. Write your code and necessary tests
4. Run your tests (`bundle exec rspec`)
5. Commit your changes (`git commit -am 'Add some feature'`)
6. Push to the branch (`git push origin feature/my-new-feature`)
7. Create pull request and be awesome!


## Credits

Hyper made this. We're a digital communications agency with a passion for good code,
and if you're using this library we probably want to hire you.
