# Cellular

Sending and receiving SMSs with Ruby through pluggable backends.

**Supported Ruby versions: 1.9 or higher**

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
end
```


### Available Backends

* Sendega (http://sendega.com/)


### Sending SMSs

The options supported may differ between backends.

```ruby
sms = Cellular::SMS.new(
  recipient: "47xxxxxxxx",
  sender: 'Custom sender',
  country: 'NO',
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
