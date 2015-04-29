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

    describe 'the returned User instance' do
      it 'represents all the Freshdesk JSON fields as instance variables' do
        user = described_class.find_by_email(user_email)
        expect(user.respond_to?(:email)).to be(true)
      end
    end
  end

  describe '#find_by_id' do
    let(:user_id) { 'abcde' }
    let(:url) { endpoint.user_by_id_path(user_id) }
    let(:response_body) { '{"user":{"email":"james.rucker@legitscript.com"}}'}

    before do
      stub_request(:get, url).to_return(status: 200, body: response_body, headers: {})
    end

    it 'calls the Freshdesk endpoint for getting user by ID' do
      described_class.find_by_id(user_id)
      expect(WebMock).to have_requested(:get, url)
    end

    it 'parses JSON and returns a User instance' do
      user = described_class.find_by_id(user_id)
      expect(user.email).to eq('james.rucker@legitscript.com')
    end
  end

  describe '#create' do
    let(:email) { 'user@example.com' }
    let(:name) { 'Bob the Builder' }
    let(:url) { endpoint.create_user_path }
    let(:response_body) { '{"user":{"email":"user@example.com", "name": "Bob the Builder"}}'}

    before do
      stub_request(:post, url).to_return(status: 200, body: response_body, headers: {})
    end

    it 'posts to the Freshdesk endpoint for creating a new user' do
      described_class.create(email, name)
      expect(WebMock).to have_requested(:post, url)
    end

    it 'creates and returns a User instance' do
      user = described_class.create(email, name)
      expect(user.email).to eq('user@example.com')
      expect(user.name).to eq('Bob the Builder')
    end
  end
end
