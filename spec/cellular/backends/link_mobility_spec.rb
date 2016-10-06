require 'spec_helper'

describe Cellular::Backends::LinkMobility do
  let(:recipient) { '+15005550004' }
  let(:sender)    { '+15005550006' }
  let(:message)   { 'This is an SMS message' }
  let(:partner_id)   { 1234 }

  let(:options) do
    {
      recipient: recipient,
      sender: sender,
      message: message,
    }
  end

  let(:payload) do
    {
      source: sender,
      destination: recipient,
      userData: message,
      platformId: 'COMMON_API',
      platformPartnerId: partner_id
    }.to_json
  end

  before do
    Cellular.config.username = 'username'
    Cellular.config.password = 'password'
    Cellular.config.backend = Cellular::Backends::LinkMobility
    Cellular.config.partner_id = 1234
  end

  describe '::deliver' do
    before do
      stub_request(:post, 'https://username:password@wsx.sp247.net/sms/send')
        .to_return(
          status: [200, 'OK'],
          body: fixture('backends/link_mobility/success.json'),
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    it 'uses HTTParty to deliver an SMS' do
      expect(HTTParty).to receive(:post).with(
        described_class.sms_url,
        body: payload,
        headers: described_class::HTTP_HEADERS,
        basic_auth: described_class.link_mobility_config
      ).and_call_original

      described_class.deliver(options)
    end

    context 'when successful' do
      it 'returns a status code and message' do
        expect(described_class.deliver(options)).to eq [
          'Queued'
        ]
      end
    end

    context 'when not successful' do
      before do
        stub_request(:post, 'https://username:password@wsx.sp247.net/sms/send')
          .to_return(
            status: [403, 'FORBIDDEN'],
            body: fixture('backends/link_mobility/failure.json'),
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it 'returns a status code and message' do
        expect(described_class.deliver(options)).to eq [
          'Unable to access SMSC credentials'
        ]
      end
    end
  end

  describe '::link_mobility_config' do
    it 'returns the config for twilio' do
      expect(described_class.link_mobility_config).to eq(
        username: 'username',
        password: 'password'
      )
    end
  end

  describe '::sms_url' do
    it 'returns the full sms gateway url' do
      expect(described_class.sms_url).to eq(
        'https://wsx.sp247.net/sms/send'
      )
    end
  end

  describe '::payload' do
    it 'returns the request payload' do
      options[:batch] = recipient
      expect(described_class.payload(options)).to eq(payload)
    end
  end

  describe '::recipients_batch' do
    it 'wraps recipient option into an array' do
      result = described_class.recipients_batch(recipient: recipient)
      expect(result).to eq [recipient]
    end

    it 'return recipients option as-is' do
      result = described_class.recipients_batch(
        recipients: [recipient, recipient]
      )
      expect(result).to eq [recipient, recipient]
    end
  end
end
