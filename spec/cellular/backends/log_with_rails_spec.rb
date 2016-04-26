require 'spec_helper'

describe Cellular::Backends::Log do
  let(:recipient) { '47xxxxxxxx' }
  let(:sender)    { 'Custom sender' }
  let(:message)   { 'This is an SMS message' }
  let(:price)     { 100 }
  let(:country)   { 'NO ' }

  let(:options) do
    {
      recipient: recipient,
      sender: sender,
      message: message,
      price: price
    }
  end

  before do
    # mock rails, we're pretending we're in a rails env
    rails = Class.new
    def rails.logger
      @logger ||= Cellular::Logger.new
    end
    Object.const_set(:Rails, rails)

    Cellular.config.username = 'username'
    Cellular.config.password = 'password'
    Cellular.config.delivery_url = nil
    Cellular.config.logger = nil # so it will autowire
  end

  after do
    Object.send :remove_const, :Rails
  end

  describe '::deliver' do
    let(:deliveries) { Cellular.deliveries }

    it 'logs the message' do
      expect(Rails.logger).to receive(:info)
      described_class.deliver(options)
    end
  end
end
