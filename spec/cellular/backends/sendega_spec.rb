require 'spec_helper'

describe Cellular::Backends::Sendega do

  let(:recipient) { '47xxxxxxxx' }
  let(:sender)    { 'Custom sender' }
  let(:message)   { 'This is an SMS message' }
  let(:price)     { 100 }
  let(:country)   { 'NO '}
  let(:recipients){ (1..300).to_a.map!{|n| "47xxxxxxx#{n}"} }
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

  let(:payload){
    {
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

      expect(client).to receive(:call).with(:send, message:
      payload).and_return result

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

  describe 'success_message' do
    it 'should return this message' do
      expect(
        described_class.success_message)
      .to eq 'Message is received and is being processed.'
    end
  end


  describe 'payload' do
    it 'should return the whole payload' do
      expect(described_class.payload(options, recipient)).to eq(payload)
   end
  end

  describe 'savon_config' do
    it 'should return a hash with config' do
      expect(described_class.savon_config)
      .to eq({
           username: Cellular.config.username,
           password: Cellular.config.password,
           dlrUrl: Cellular.config.delivery_url
        })
    end
  end

  describe 'recipient_batch' do
    it 'should split recipients into arrays of 100 then join them with ,' do
      check = described_class.recipients_batch({receipients:recipients}).length
      expect(check).to eq 3
    end

    it 'should put recipient into one array' do
      check = described_class.recipients_batch({receipient:recipient}).length
      expect(check).to eq 1
    end
  end
end
