require 'spec_helper'

describe Cellular::SMS do

  let(:recipient) { '47xxxxxxxx' }
  let(:sender)    { 'Custom sender' }
  let(:message)   { 'This is an SMS message' }
  let(:price)     { 100 }
  let(:country)   { 'NO '}

  subject do
    described_class.new(
      recipient: recipient,
      sender: sender,
      message: message,
      price: price,
      country: country
    )
  end

  before do
    Cellular.config.backend = Cellular::Backends::Sendega
  end

  describe '#initialize' do
    its(:recipient) { should eq recipient }
    its(:sender)    { should eq sender }
    its(:message)   { should eq message }
    its(:price)     { should eq price }
    its(:country)   { should eq country }

    it { should_not be_delivered }
  end

  describe '#deliver' do
    before do
      expect(Cellular::Backends::Sendega).to receive(:deliver).with(
        recipient: recipient,
        sender: sender,
        price: price,
        country: country,
        message: message
      )
    end

    it 'uses configured backend and marks SMS as delivered' do
      subject.deliver
      expect(subject).to be_delivered
    end
  end

  describe '#save' do
    it 'has not been implemented yet' do
      expect do
        subject.save
      end.to raise_error NotImplementedError
    end
  end

  describe '#receive' do
    it 'has not been implemented yet' do
      expect do
        subject.receive
      end.to raise_error NotImplementedError
    end
  end

end
