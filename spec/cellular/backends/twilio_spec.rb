require 'spec_helper'

describe Cellular::Backends::Twilio do

  let(:recipient) { '+15005550004' }
  let(:sender)    { '+15005550006' }
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
    Cellular.config.backend = Cellular::Backends::Twilio
  end

  describe '::deliver' do
    before do
      stub_request(:post, "https://account_sid:auth_token@api.twilio.com/2010-04-01/Accounts/account_sid/Messages").
       to_return(:status => [201, "CREATED"], :body => fixture('backends/twilio/success.json'), :headers => {'Content-Type' => 'application/json'})
    end

    it 'does uses HTTParty to deliver an SMS' do
      expect(HTTParty).to receive(:post).with(described_class::sms_url, body:
        payload, headers: described_class::HTTP_HEADERS, basic_auth: described_class::twilio_config).and_call_original

      described_class.deliver(options)
    end

    context 'when successful' do
      it 'does return a status code and message' do
        expect(described_class.deliver(options)).to eq([
          201,
          'CREATED'
        ])
      end
    end

    context 'when not successful' do
      before do
        stub_request(:post, "https://account_sid:auth_token@api.twilio.com/2010-04-01/Accounts/account_sid/Messages").
          to_return(:status => [400, "BAD REQUEST"], :body => fixture('backends/twilio/failure.json'), :headers => {'Content-Type' => 'application/json'})
      end

      it 'does return a status code and message' do
        expect(described_class.deliver(options)).to eq([
          400,
          'BAD REQUEST'
        ])
      end
    end

  end

  describe '::twilio_config' do
    it 'does return the config for twilio' do
      expect(described_class.twilio_config).to eq(
        {
          username: 'account_sid',
          password: 'auth_token'
        })
    end
  end

  describe '::sms_url' do
    it 'does return the full sms gateway url' do
      expect(described_class.sms_url).to eq(
        "https://api.twilio.com/2010-04-01/Accounts/account_sid/Messages"
      )
    end
  end

  describe '::payload' do
    it 'does return the request payload' do
      options[:batch] = recipient
      expect(described_class.payload(options)).to eq(payload)
    end
  end

  describe '::parse_response' do
    before do
      subject { Object.new }
    end

    context 'when not successful' do
      it 'does return the formatted success response' do
        subject.stub(:code).and_return(201)
        subject.stub(:message).and_return('CREATED')

        expect(described_class.parse_response(subject)).to eq(
          [
            201,
            'CREATED'
          ]
        )
      end
    end

    context 'when not successful' do
      it 'does return the formatted failed response' do
        subject.stub(:code).and_return(400)
        subject.stub(:message).and_return('BAD REQUEST')

        expect(described_class.parse_response(subject)).to eq(
          [
            400,
            'BAD REQUEST'
          ]
        )
      end
    end
  end

  describe '::recipients_batch' do
    it 'does wrap recipient option into a array' do
      expect(described_class.recipients_batch({recipient: recipient}))
        .to eq([recipient])
    end
    it 'does return recipients option as it is' do
      expect(described_class.recipients_batch({recipients: [recipient,recipient]}))
        .to eq([recipient,recipient])
    end
  end
end
