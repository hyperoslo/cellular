require 'spec_helper'

describe Cellular::Backends::Backend do
  describe '::deliver' do
    it 'has not been implemented yet' do
      expect do
        described_class.deliver
      end.to raise_error NotImplementedError
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
