require 'spec_helper'

describe Cellular::Backends::Log do

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
    Cellular.config.username = 'username'
    Cellular.config.password = 'password'
    Cellular.config.delivery_url = nil
  end

  describe '::deliver' do
    it 'logs the message' do
      expect(STDOUT).to receive(:puts)
      described_class.deliver(options, savon_options)
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
