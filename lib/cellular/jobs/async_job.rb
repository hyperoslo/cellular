require 'active_job'

class Cellular::Jobs::AsyncJob < ActiveJob::Base
  queue_as :cellular

  def perform(sms_options)
    sms_options.keys.each do |key|
      sms_options[key.to_sym] = sms_options.delete key
    end

    sms = Cellular::SMS.new sms_options
    sms.deliver
  end
end
