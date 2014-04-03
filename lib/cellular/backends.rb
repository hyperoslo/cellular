module Cellular
  module Backends
    autoload :CoolSMS, 'cellular/backends/cool_sms'
    autoload :Sendega, 'cellular/backends/sendega'
    autoload :Log,     'cellular/backends/log'
    autoload :Test,    'cellular/backends/test'
  end
end
