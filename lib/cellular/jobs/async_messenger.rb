class Cellular::Jobs::AsyncMessenger
  include Sidekiq::Worker

  sidekiq_options queue: :cellular, retry: false

  def perform(sms_options)
    sms_options.keys.each do |key|
      sms_options[key.to_sym] = sms_options.delete key
    end

    sms = Cellular::SMS.new sms_options
    sms.deliver
  end

end
