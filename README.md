# freshdesk-ruby

A Ruby wrapper for the Freshdesk Developer's API.

### Supported APIs:

* Tickets
  - (GET) View a ticket
  - (GET) View a list of tickets

### Usage:

1.) Add it to your Gemfile.

```ruby
  gem 'freshdesk-ruby', git: '<git url>/freshdesk-ruby.git', branch: 'master'
```

2.) Install.

```bash
  $ bundle install
```

3.) In an initializer, configure the gem to use your API key and subdomain when it makes HTTP requests.

```ruby
  Freshdesk.configure do |config|
    config.api_key = 'my company api key'
    config.subdomain = 'my company subdomain'
  end
```

You can configure the following properties: your company's subdomain, the protocol (https or http), the API key, your company's password, and company's username.
