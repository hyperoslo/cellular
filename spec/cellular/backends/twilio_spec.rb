require 'spec_helper'

describe Cellular::Backends::Twilio do

  let(:recipient) { '+47xxxxxxxx' }
  let(:sender)    { 'Custom sender' }
  let(:message)   { 'This is an SMS message' }
  let(:price)   { 0.001 }

  let(:options) {
    {
      recipient: recipient,
      sender: sender,
      message: message,
      price: price
    }
  }

  let(:auth) {
    {
      username: 'account_sid',
      password: 'auth_token'
    }
  }

  let(:payload) {
    {
      From: sender,
      To: recipient,
      Body: message,
      MaxPrice: price
    }
  }

  before do
    Cellular.config.username = 'account_sid'
    Cellular.config.password = 'auth_token'
  end

  describe '::deliver' do

  end

  describe '::twilio_config' do
    it 'should return the config for twilio' do
      expect(described_class.twilio_config).to eq(
        {
          username: 'account_sid',
          password: 'auth_token'
        })
    end
  end

  describe '::payload' do
    it 'returns the payload' do
      options[:batch] = recipient
      expect(described_class.payload(options)).to eq(payload)
    end
  end

  describe '::recipients_batch' do
    it 'should wrap recipient option into a array' do
      expect(described_class.recipients_batch({recipient: recipient}))
        .to eq([recipient])
    end
    it 'should return recipients option as it is' do
      expect(described_class.recipients_batch({recipients: [recipient,recipient]}))
        .to eq([recipient,recipient])
    end
  end

end
