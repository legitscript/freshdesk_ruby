# freshdesk_ruby

A Ruby wrapper for the Freshdesk Developer's API.

## Supported APIs:

### Tickets
* (GET) View a ticket
* (GET) View a list of tickets
* (POST) Create a new ticket
* (DELETE) Delete a ticket
* (GET) View all ticket fields

## Usage:

1.) Add it to your Gemfile.

```ruby
  gem 'freshdesk_ruby', git: 'git://github.com/legitscript/freshdesk_ruby.git', branch: 'master'
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

You can configure the following properties:

* your subdomain
* the protocol (https or http)
* the API key
* your password
* your username

Please see the examples.txt file for usage examples.
