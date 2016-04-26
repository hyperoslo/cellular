require 'active_job'

# Delivers SMSs asynchronously through ActiveJob
class Cellular::Jobs::AsyncMessenger < ActiveJob::Base
  queue_as :cellular

  def perform(sms_options)
    sms_options.keys.each do |key|
      sms_options[key.to_sym] = sms_options.delete key
    end

    sms = Cellular::SMS.new sms_options
    sms.deliver
  end
end
