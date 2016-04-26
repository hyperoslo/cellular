require 'spec_helper'

describe Cellular::Backends::CoolSMS do
  let(:recipient) { '47xxxxxxxx' }
  let(:sender)    { 'Custom sender' }
  let(:message)   { 'This is an SMS message' }

  let(:options) do
    {
      recipient: recipient,
      sender: sender,
      message: message
    }
  end

  let(:payload) do
    {
      username: 'username',
      password: 'password',
      from: sender,
      to: recipient,
      message: message,
      charset: 'utf-8',
      resulttype: 'xml',
      lang: 'en'
    }
  end

  before do
    Cellular.config.username = 'username'
    Cellular.config.password = 'password'
  end

  describe '::deliver' do
    before do
      stub_request(:get, 'https://sms.coolsmsc.dk/?charset=utf-8&from=Custom%20sender&lang=en&message=This%20is%20an%20SMS%20message&password=password&resulttype=xml&to=47xxxxxxxx&username=username')
        .to_return headers: { 'Content-Type' => 'text/xml' }, body: fixture('backends/cool_sms/success.xml')
    end

    it 'uses HTTParty to deliver an SMS' do
      expect(HTTParty).to receive(:get).with(
        described_class::GATEWAY_URL,
        query: payload
      ).and_call_original

      described_class.deliver(options)
    end

    context 'when successful' do
      it 'returns success and a message' do
        expect(described_class.deliver(options)).to eq [
          'success',
          'The message was sent correctly.'
        ]
      end
    end

    context 'when not successful' do
      before do
        stub_request(:get, 'https://sms.coolsmsc.dk/?charset=utf-8&from=Custom%20sender&lang=en&message=This%20is%20an%20SMS%20message&password=password&resulttype=xml&to=47xxxxxxxx&username=username')
          .to_return headers: { 'Content-Type' => 'text/xml' }, body: fixture('backends/cool_sms/failure.xml')
      end

      it 'returns failure and a message' do
        expect(described_class.deliver(options)).to eq [
          'failure',
          'Access denied.'
        ]
      end
    end
  end

  describe '::parse_response' do
    it 'should return the correct response' do
      message = ['success', 'The message was sent correctly.']

      check = { 'status' => message[0], 'result' => message[1] }
      second_check = {
        'status' => message[0],
        'message' => { 'result' => message[1] }
      }

      expect(described_class.parse_response(check)).to eq(message)
      expect(described_class.parse_response(second_check)).to eq(message)
    end
  end

  describe '::coolsms_config' do
    it 'should return the config for coolsms' do
      expect(described_class.coolsms_config).to eq(
        username: Cellular.config.username,
        password: Cellular.config.password
      )
    end
  end

  describe '::defaults_with' do
    it 'should return the whole query' do
      options[:batch] = recipient
      expect(described_class.defaults_with(options)).to eq(payload)
    end
  end

  describe '::recipients_batch' do
    it 'should wrap recipient option into a array' do
      result = described_class.recipients_batch(recipient: recipient)
      expect(result).to eq([recipient])
    end
    it 'should return recipients option as it is' do
      result = described_class.recipients_batch(
        recipients: [recipient, recipient]
      )
      expect(result).to eq([recipient, recipient])
    end
  end
end
