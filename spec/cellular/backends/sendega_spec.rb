require 'spec_helper'

describe Cellular::Backends::Sendega do

  let(:recipient) { '47xxxxxxxx' }
  let(:sender)    { 'Custom sender' }
  let(:message)   { 'This is an SMS message' }
  let(:price)     { 100 }
  let(:country)   { 'NO '}

  let(:options) {
    {
      recipient: recipient,
      sender: sender,
      message: message,
      price: price
    }
  }
  let(:savon_options) {
    {
      log: false
    }
  }

  before do
    stub_request(:get, described_class::GATEWAY_URL).
      to_return body: fixture('backends/sendega/service.wsdl')

    Cellular.config.username = 'username'
    Cellular.config.password = 'password'
    Cellular.config.delivery_url = nil
  end

  describe '::deliver' do
    it 'uses Savon to deliver an SMS' do
      client = double()
      Savon.stub(:client).and_return client

      result = double(body: {send_response: {send_result: {}}})

      expect(client).to receive(:call).with(:send, message: {
        username: Cellular.config.username,
        password: Cellular.config.password,
        sender: sender,
        destination: recipient,
        pricegroup: price,
        contentTypeID: 1,
        contentHeader: '',
        content: message,
        dlrUrl: nil,
        ageLimit: 0,
        extID: '',
        sendDate: '',
        refID: '',
        priority: 0,
        gwID: 0,
        pid: 0,
        dcs: 0
      }).and_return result

      described_class.deliver(options, savon_options)
    end

    context 'when successful' do
      before do
        stub_request(:post, 'https://smsc.sendega.com/Content.asmx').
          to_return body: fixture('backends/sendega/success.xml')
      end

      it 'returns a success code and a message' do
        expect(described_class.deliver(options, savon_options)).to eq [
          0,
          'Message is received and is being processed.'
        ]
      end
    end

    context 'when not successful' do
      before do
        stub_request(:post, 'https://smsc.sendega.com/Content.asmx').
          to_return body: fixture('backends/sendega/failure.xml')
      end

      it 'returns an error code and a message' do
        expect(described_class.deliver(options, savon_options)).to eq [
          9001,
          'Not validated - Username and password does not match (e)'
        ]
      end
    end
  end

  describe '::receive' do
    it 'has not been implemented yet' do
      expect do
        described_class.receive ''
      end.to raise_error NotImplementedError
    end
  end

end
