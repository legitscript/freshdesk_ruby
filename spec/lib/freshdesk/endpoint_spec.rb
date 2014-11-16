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

  describe '#tickets_path' do
    context 'when an options hash is given' do
      it 'turns the options into query string parameters' do
        url = endpoint.tickets_path(page: 2, foo: 'bar')
        expect(url).to include('page=2')
        expect(url).to include('foo=bar')
      end
    end

    context 'when no options hash is given' do
      it 'adds default query string parameters' do
        url = endpoint.tickets_path
        expect(url).to include('format=json')
      end
    end
  end
end
