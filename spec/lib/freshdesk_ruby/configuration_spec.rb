require 'spec_helper'

describe Freshdesk::Configuration do
  let(:config) { described_class.new }

  describe 'configuring' do
    it 'updates base endpoint when the subdomain has changed' do
      config.subdomain = 'mynewsubdomain'
      expect(config.base_endpoint).to include('mynewsubdomain')
    end

    it 'updates base endpoint when the protocol has changed' do
      config.protocol = 'http'
      expect(config.base_endpoint).to include('http://')
    end
  end
end
