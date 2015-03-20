require 'spec_helper'

describe Cellular::Jobs::AsyncJob do
  let(:sms_stub)    { double "SMS", deliver: true }
  let(:sms_options) { { "recipient" => "12345678", "text" => "Foo" } }

  it 'creates a new SMS object' do
    symbolized_sms_options = { recipient: "12345678", text: "Foo" }

    expect(Cellular::SMS).to receive(:new)
      .with(symbolized_sms_options)
      .and_return sms_stub

    subject.perform sms_options
  end

  it "delivers the SMS" do
    allow(Cellular::SMS).to receive(:new).and_return sms_stub

    expect(sms_stub).to receive :deliver

    subject.perform sms_options
  end
end
