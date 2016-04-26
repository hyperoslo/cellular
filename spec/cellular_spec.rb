require 'spec_helper'

describe Cellular do
  describe '::config' do
    it 'creates a new configuration if none exists' do
      described_class.config = nil
      expect(described_class.config).to be_a described_class::Configuration
    end

    it 'retrieves any existing configuration' do
      config = described_class::Configuration.new
      described_class.config = config
      expect(described_class.config).to eq config
    end
  end

  describe '::configure' do
    it 'sets configuration options correctly' do
      described_class.config = nil
      described_class.configure do |config|
        config.username = 'username'
      end
      expect(described_class.config.username).to eq 'username'
    end
  end
end
