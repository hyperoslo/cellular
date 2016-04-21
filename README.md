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
  config.backend = Cellular::Backends::Sendega
  config.sender = 'Default custom sender'
  config.country_code = 'NO'
end
```

Cellular uses Rails' [ActiveJob](http://edgeguides.rubyonrails.org/active_job_basics.html)
interface to interact with queue backends. Read appropriate documentation to set up queue.


### Available Backends

* [Cellular::Backends::CoolSMS](http://coolsms.com/)
* [Cellular::Backends::Sendega](http://sendega.com/)
* [Cellular::Backends::Twilio](http://twilio.com/)
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


#### Delayed SMSs delivery

You can also send texts asynchronously, which is great if you're in a Rails app
and are concerned that it might time out or something. To use it, just call
`deliver_async` instead of `deliver` on the SMS object:

```ruby
sms = Cellular::SMS.new(
  recipient: '+47xxxxxxxx',
  sender: '+47xxxxxxxx',
  message: 'This is an SMS message'
)

sms.deliver_async
```

This will create a delayed job for you on the **cellular** queue, so make sure
that your queue processor is running.

To override queue name, use **queue** option

```ruby
sms.deliver_async(queue: :urgent)
```
Using ActiveJob, Cellular allows you to schedule the time when an SMS will be sent.
Just call `deliver_async(wait_until: timestamp)` or `deliver_async(wait: time)` on the SMS object:

```ruby
sms = Cellular::SMS.new(
  recipient: '+47xxxxxxxx',
  sender: '+47xxxxxxxx',
  message: 'This is an SMS message'
)

sms.deliver_async(wait_until: Date.tomorrow.noon)
```

## Troubleshooting

If you are using Twilio as a backend, please make sure you add or (port)[https://www.twilio.com/help/faq/porting] a phone number to your account so, that you can use that as a sender option. You won't be able to send messages from any phone number unless you port it to Twilio. 

Also, make sure phone numbers are in valid international format: 
[`+47xxxxxx`, `+370xxxxx`]

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create pull request


## Credits

Hyper made this. We're a digital communications agency with a passion for good code,
and if you're using this library we probably want to hire you.
