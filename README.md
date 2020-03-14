# Helpscout::Mailbox::V2::Client

Super simple REST client for the HelpScout V2 Mailbox API

It uses the following gems to work with HelpScout

- [Helpscout::Api::Auth](https://github.com/jayco/helpscout-api-auth.git)
- [Helpscout::Mailbox::Paths](https://github.com/jayco/helpscout-mailbox-paths.git)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'helpscout-mailbox-v2-client'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install helpscout-mailbox-v2-client

## Usage

### Helpscout::Mailbox::V2::Client::Http.new

Creates a new Client class and authorises the client with HelpScout

| Parameter       | Type     | Description                                                            |
| :-------------- | :------- | :--------------------------------------------------------------------- |
| `client_id`     | `string` | **Required** HelpScout API client id                                   |
| `client_secret` | `string` | **Required** HelpScout API client secret                               |
| `base_url`      | `string` | **Optional** HelpScout API url (defaults to https://api.helpscout.net) |

```ruby
require 'helpscout/mailbox/client'

client = Helpscout::Mailbox::V2::Client::Http.new(client_id: 'some id', client_secret: 'keep it secret')
# => 'BMEv1lmcNgDBpOFNHo8TPlODMrF3BG5T'

```

### Helpscout::Mailbox::V2::Client.generate_path

Generates path and method mappings for the api - see [Helpscout::Mailbox::Paths](https://github.com/jayco/helpscout-mailbox-paths.git)

| Parameter | Type     | Description                                                                                                      |
| :-------- | :------- | :--------------------------------------------------------------------------------------------------------------- |
| `path`    | `symbol` | **Required** See [mappings](https://github.com/jayco/helpscout-mailbox-paths#helpscoutmailboxpathsgenerate_path) |
| `values`  | `string` | **Required** See [mappings](https://github.com/jayco/helpscout-mailbox-paths#helpscoutmailboxpathsgenerate_path) |

```ruby
path_map = client.generate_path :v2_conversation, {conversation_id: 1089909636}
# => {:method=>"GET", :path=>"/v2/conversations/1089909636"}

```

### Helpscout::Mailbox::V2::Client.request

Sends a request

| Parameter | Type     | Description              |
| :-------- | :------- | :----------------------- |
| `method`  | `string` | **Required** HTTP method |
| `path`    | `string` | **Required** API path    |
| `params`  | `hash`   | **Optional** URL params  |

```ruby
path_map = client.generate_path :v2_conversation, {conversation_id: 1089909636}
# => {:method=>"GET", :path=>"/v2/conversations/1089909636"}

response = client.request path_map[:method], path_map[:path], {eat: 'cheese'}
# => <Net::HTTPOK 200  readbody=true>
```

### Helpscout::Mailbox::V2::Client.json_request

Sends a JSON request

| Parameter | Type     | Description              |
| :-------- | :------- | :----------------------- |
| `method`  | `string` | **Required** HTTP method |
| `path`    | `string` | **Required** API path    |
| `body`    | `hash`   | **Required** Payload     |
| `params`  | `hash`   | **Optional** URL params  |

```ruby
path_map = client.generate_path :v2_conversations_tags_update, {conversation_id: 1089909636}
# => {:method=>"PUT", :path=>"/v2/conversations/1089909636/tags"}

response = client.json_request path_map[:method], path_map[:path], { tags: ['clam'] }, {eat: 'cheese'}
# => <Net::HTTPOK 200  readbody=true>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/helpscout-mailbox-v2-client. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/helpscout-mailbox-v2-client/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Helpscout::Mailbox::V2::Client project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/helpscout-mailbox-v2-client/blob/master/CODE_OF_CONDUCT.md).
