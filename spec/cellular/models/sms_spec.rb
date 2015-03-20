require 'spec_helper'

describe Cellular::SMS do

  let(:recipient)    { '47xxxxxxxx' }
  let(:sender)       { 'Custom sender' }
  let(:message)      { 'This is an SMS message' }
  let(:price)        { 100 }
  let(:country_code) { 'NO'}
  let(:recipients)   { nil }

  subject do
    described_class.new(
      recipients: recipients,
      recipient: recipient,
      sender: sender,
      message: message,
      price: price,
      country_code: country_code
    )
  end

  before do
    Cellular.config.backend = Cellular::Backends::Sendega
  end

  describe '#initialize' do
    it{ expect(subject.recipient).to eq recipient }
    it{ expect(subject.sender).to eq sender }
    it{ expect(subject.message).to eq message }
    it{ expect(subject.price).to eq price }
    it{ expect(subject.country_code).to eq country_code }

    it { should_not be_delivered }

    context 'when sender omitted' do
      before do
        Cellular.config.sender = 'Hyper'
      end

      subject { described_class.new }
      it{ expect(subject.sender).to eq 'Hyper' }
    end

    context 'when price omitted' do
      before do
        Cellular.config.price = 5
      end

      subject { described_class.new }

      it{ expect(subject.price).to be 5 }
    end

    context 'when country omitted' do
      before do
        Cellular.config.country_code = 'NL'
      end

      subject { described_class.new }
      it{ expect(subject.country_code).to eq 'NL'}
    end
  end

  describe '#deliver' do
    before do
      expect(Cellular::Backends::Sendega).to receive(:deliver).with(
        recipients: recipients,
        recipient: recipient,
        sender: sender,
        price: price,
        country_code: country_code,
        message: message
      )
    end

    it 'uses configured backend and marks SMS as delivered' do
      subject.deliver
      expect(subject).to be_delivered
    end
  end

  describe "#deliver_async" do
    it "makes ActiveJob schedule an SMS job" do
      sms_options = {
        receiver: "12345678",
        message: "Test SMS"
      }
      wait = 100

      expect_any_instance_of(ActiveJob::ConfiguredJob)
        .to receive(:perform_later)
        .with(sms_options)

      sms = Cellular::SMS.new sms_options

      allow(ActiveJob::Base).to receive(:queue_adapter).and_return ActiveJob::QueueAdapters::TestAdapter.new
      allow(sms).to receive(:options).and_return sms_options

      sms.deliver_async(wait: wait)
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

  describe '#country' do
    it 'issues a deprecation warning' do
      expect(subject).to receive(:warn)
      subject.country
    end

    it 'returns country_code' do
      allow(subject).to receive(:warn)
      expect(subject.country).to eq(subject.country_code)
    end
  end

  describe '#country=' do
    it 'issues a deprecation warning' do
      expect(subject).to receive(:warn)
      subject.country = 'Test'
    end

    it 'assigns country_code' do
      allow(subject).to receive(:warn)
      subject.country = 'Test'
      expect(subject.country_code).to eq('Test')
    end
  end

end
