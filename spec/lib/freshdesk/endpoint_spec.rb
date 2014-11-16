require 'spec_helper'

describe Freshdesk::Endpoint do
  let(:endpoint) { described_class.new }
  let(:config) { Freshdesk.configuration }

  describe '#basic_auth_username' do
    context 'when a username has been set' do
      before do
        config.username = 'myusername'
      end

      it 'returns the username' do
        expect(endpoint.basic_auth_username).to eq('myusername')
      end
    end

    context 'when a username has not been set' do
      let(:key) { 'a key' }
      before do
        config.api_key = key
        config.username = ''
      end

      it 'defaults to the API key' do
        expect(endpoint.basic_auth_username).to eq(key)
      end
    end
  end
end
