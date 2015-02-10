require 'spec_helper'

describe Freshdesk::User do
  let(:response_body) do
    path = File.join('spec', 'support', 'responses', 'list_of_users.json')
    full_path = File.expand_path(path)
    File.read(full_path)
  end

  let(:parsed_data) { JSON.parse(response_body).first['user'] }

  let(:user) { described_class.new(parsed_data) }

  let(:endpoint) { Freshdesk::Endpoint.new }

  let(:request_body) { Freshdesk::RequestBody.new }

  it 'has methods mapping to JSON response fields' do
    expect(user).to respond_to(:id)
    expect(user).to respond_to(:email)
  end

  describe '#find_by_email' do
    let(:user_email) { 'james.rucker@legitscript.com' }

    let(:filepath) do
      path = File.join('spec', 'support', 'responses', 'list_of_users.json')
      File.expand_path(path)
    end

    let(:response_body) { File.read(filepath) }

    before do
      stub_request(:get, endpoint.list_users_path("email is james.rucker@legitscript.com"))
         .to_return(status: 200, body: response_body, headers: {})

    end

    it 'returns a single user with a given email' do
      user = described_class.find_by_email(user_email)
      expect(user).to be_a(described_class)
    end
  end
end
