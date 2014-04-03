require 'spec_helper'

describe Cellular::Backends::Test do

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
    let(:deliveries) { Cellular.deliveries }
    let(:delivery)   { deliveries.first }

    before do
      Cellular.deliveries.clear
    end

    it 'appends the message to deliveries' do
      described_class.deliver message: 'This is a message'
      expect(deliveries.count).to eq 1
    end

    it 'stores the message of the message' do
      described_class.deliver message: 'This is a message'
      expect(delivery).to eq 'This is a message'
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
