require 'spec_helper'

describe Cellular::Backends::Twilio do

  let(:recipient) { '+15005550004' }
  let(:sender)    { '+15005550006' }
  let(:message)   { 'This is an SMS message' }
  let(:price)   { 0.001 }
  let(:account_sid) { 'AC800d5bd49542346c71674b49851a1bbf' }
  let(:auth_token) { 'abe0494797c9323b534139c5ff46dcfe' }

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
    Cellular.config.backend = Cellular::Backends::Twilio
  end

  describe '::deliver' do
    before do
      stub_request(:post, "https://account_sid:auth_token@api.twilio.com/2010-04-01/Accounts/account_sid/Messages").
       with(:body => "From=%2B15005550006&To=%2B15005550004&Body=This%20is%20an%20SMS%20message&MaxPrice=0.001",
            :headers => {'Accept'=>'application/json', 'Accept-Charset'=>'utf-8', 'User-Agent'=>'cellular/2.0.0 (ruby/x86_64-darwin15 2.3.0-p0)'}).
       to_return(:status => [201, "CREATED"], :body => fixture('backends/twilio/success.json'), :headers => {'Content-Type' => 'application/json'})
    end

    it 'uses HTTParty to deliver an SMS' do
      expect(HTTParty).to receive(:post).with(described_class::sms_url, body:
        payload, headers: described_class::HTTP_HEADERS, basic_auth: described_class::twilio_config).and_call_original

      described_class.deliver(options)
    end

    context 'when successful' do
      it 'returns success and a message' do
        expect(described_class.deliver(options)).to eq([
          201,
          'CREATED'
        ])
      end
    end

    context 'when not successful' do
      before do
        stub_request(:post, "https://account_sid:auth_token@api.twilio.com/2010-04-01/Accounts/account_sid/Messages").
          with(:body => "From=%2B15005550006&To=%2B15005550004&Body=This%20is%20an%20SMS%20message&MaxPrice=0.001",
            :headers => {'Accept'=>'application/json', 'Accept-Charset'=>'utf-8', 'User-Agent'=>'cellular/2.0.0 (ruby/x86_64-darwin15 2.3.0-p0)'}).
          to_return(:status => [400, "BAD REQUEST"], :body => fixture('backends/twilio/failure.json'), :headers => {'Content-Type' => 'application/json'})
      end

      it 'returns failure and a message' do
        expect(described_class.deliver(options)).to eq([
          400,
          'BAD REQUEST'
        ])
      end
    end

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
