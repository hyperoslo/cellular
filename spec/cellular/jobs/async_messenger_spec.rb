require 'spec_helper'

describe Cellular::Jobs::AsyncMessenger do
  let(:sms_stub)    { double "SMS", deliver: true }
  let(:sms_options) { { "recipient" => "12345678", "text" => "Foo" } }

  before do
    allow(Cellular::SMS).to receive(:new).and_return sms_stub
  end

  it 'creates a new SMS object' do
    symbolized_sms_options = { recipient: "12345678", text: "Foo" }

    subject.perform sms_options

    expect(Cellular::SMS).to have_received(:new)
      .with(symbolized_sms_options)
  end

  it "delivers the SMS" do
    subject.perform sms_options

    expect(sms_stub).to have_received :deliver
  end
end
