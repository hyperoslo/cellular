module Cellular
  # Encapsulates all available backends for Cellular
  module Backends
    autoload :Backend, 'cellular/backends/backend'
    autoload :CoolSMS, 'cellular/backends/cool_sms'
    autoload :Sendega, 'cellular/backends/sendega'
    autoload :Twilio,  'cellular/backends/twilio'
    autoload :Log,     'cellular/backends/log'
    autoload :Test,    'cellular/backends/test'
  end
end
