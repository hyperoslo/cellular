require 'spec_helper'

describe Cellular::Backends::CoolSMS do

  let(:recipient) { '47xxxxxxxx' }
  let(:sender)    { 'Custom sender' }
  let(:message)   { 'This is an SMS message' }

  let(:options) {
    {
      recipient: recipient,
      sender: sender,
      message: message
    }
  }

  before do
    Cellular.config.username = 'username'
    Cellular.config.password = 'password'
  end

  describe '::deliver' do
    before do
      stub_request(:get, 'https://sms.coolsmsc.dk/?charset=utf-8&from=Custom%20sender&lang=en&message=This%20is%20an%20SMS%20message&password=password&resulttype=xml&to=47xxxxxxxx&username=username').
        to_return headers: { 'Content-Type' => 'text/xml' }, body: fixture('backends/cool_sms/success.xml')
    end

    it 'uses HTTParty to deliver an SMS' do
      expect(HTTParty).to receive(:get).with(described_class::GATEWAY_URL, query: {
        username: 'username',
        password: 'password',
        from: sender,
        to: recipient,
        message: message,
        charset: 'utf-8',
        resulttype: 'xml',
        lang: 'en'
      }).and_call_original

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
        stub_request(:get, 'https://sms.coolsmsc.dk/?charset=utf-8&from=Custom%20sender&lang=en&message=This%20is%20an%20SMS%20message&password=password&resulttype=xml&to=47xxxxxxxx&username=username').
          to_return headers: { 'Content-Type' => 'text/xml' }, body: fixture('backends/cool_sms/failure.xml')
      end

      it 'returns failure and a message' do
        expect(described_class.deliver(options)).to eq [
          'failure',
          'Access denied.'
        ]
      end
    end
  end

end
