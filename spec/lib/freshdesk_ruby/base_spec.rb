require 'spec_helper'

describe Freshdesk::Base do
  let(:endpoint) { Freshdesk::Endpoint.new }

  describe '.response_error' do
    context 'when successful' do
      let(:filepath) do
        path = File.join('spec', 'support', 'responses', 'ticket.json')
        File.expand_path(path)
      end

      let(:response_body) { File.read(filepath) }

      before do
        stub_request(:get, endpoint.tickets_path)
          .to_return(status: 200, body: response_body)
      end

      it 'returns nil' do
        response = described_class.get_request(endpoint.tickets_path)
        object = described_class.response_error(response)
        expect(object).to be_nil
      end

      context 'when response body is an empty array' do
        let(:response_body) { '[]' }

        it 'returns nil' do
          response = described_class.get_request(endpoint.tickets_path)
          object = described_class.response_error(response)
          expect(object).to be_nil
        end
      end
    end

    context 'when authentication fails' do
      let(:response_body) { '{ "require_login": true }' }

      before do
        stub_request(:get, endpoint.tickets_path)
          .to_return(status: 200, body: response_body)
      end

      it 'returns a Freshdesk::ResponseError' do
        response = described_class.get_request(endpoint.tickets_path)
        object = described_class.response_error(response)
        expect(object).to be_a(Freshdesk::ResponseError)
      end
    end

    context 'when the response code is not in the 2xx class' do
      before do
        stub_request(:get, endpoint.tickets_path)
          .to_return(status: 404, body: '{}')
      end

      it 'returns a Freshdesk::ResponseError' do
        response = described_class.get_request(endpoint.tickets_path)
        object = described_class.response_error(response)
        expect(object).to be_a(Freshdesk::ResponseError)
      end
    end

    context 'when a JSON object with an "errors" key is sent' do
      let(:response_body) { "{\"errors\":{\"require_login\":true}}" }

      before do
        stub_request(:get, endpoint.tickets_path)
          .to_return(status: 200, body: response_body)
      end

      it 'returns a Freshdesk::ResponseError' do
        response = described_class.get_request(endpoint.tickets_path)
        object = described_class.response_error(response)
        expect(object).to be_a(Freshdesk::ResponseError)
      end

      it 'includes the correct message in the exception message' do
        response = described_class.get_request(endpoint.tickets_path)
        object = described_class.response_error(response)
        expect(object.message).to eq(response_body)
      end

      context 'when the error indicates that a user with a given email address does not exist' do
        let(:response_body) { "{\"errors\":{\"no_email\":true}}" }
        let(:object) do
          response = described_class.get_request(endpoint.tickets_path)
          described_class.response_error(response)
        end

        it 'returns a Freshdesk::EmailNotFoundError' do
          expect(object).to be_a(Freshdesk::EmailNotFoundError)
        end

        it 'returns the correct message in the exception message' do
          expect(object.message).to eq('No user with that email address exists in Freshdesk; have you created one?')
        end
      end
    end
  end
end
