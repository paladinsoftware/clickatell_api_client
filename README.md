# ClickatellApiClient

[![Gem Version](https://badge.fury.io/rb/clickatell_api_client.svg)](https://badge.fury.io/rb/clickatell_api_client)
[![Build Status](https://travis-ci.org/paladinsoftware/clickatell_api_client.svg?branch=master)](https://travis-ci.org/paladinsoftware/clickatell_api_client)
[![Maintainability](https://api.codeclimate.com/v1/badges/c4b1e02d0a40e9576cea/maintainability)](https://codeclimate.com/github/paladinsoftware/clickatell_api_client/maintainability)

Ruby gem which is a wrapper for [Clickatell](https://www.clickatell.com/) API.
It allows to send a message and supports sending messages to the US (two way message) and to the rest of the World.
Gem automatically check if a number is from the USA and which type of a message should be used (two way or not).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'clickatell_api_client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install clickatell_api_client

## Configuration

First of all, configure your client.

```ruby
ClickatellApiClient.configure do |config|
  config.api_key = '123'
  config.us_api_key = '234'
  config.phone_number '+1324324231'
end
```

- `api_key` - your API key for non-two way messages
- `us_api_key` - your API key for two way messages (US only)
- `phone_number` - your phone number from Clickatell which is used to send a two way message

## Usage

In order to send a message, just use:

```ruby
ClickatellApiClient::API::SendMessage.new(
  telephone: '+1213123213132',
  message: 'Your message'
).call
```

Example response after sending a message:
```ruby
{
  message_id: '32eef0se02ed0fsdasd',
  to: '+1213123213132',
  send: 'true'
}
```

There is a possiblity, that Clickatell API returns error after trying to send a message. Here is the list of exceptions:
- `ClickatellApiClient::API::TopUpAccountError` - you don't have enought funds to send a message.
- `ClickatellApiClient::API::MissingFromNumberError` - missing sender number (used in two way messages)
- `ClickatellApiClient::API::InvalidAPIResponseError` - other API error

That's all!

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/paladinsoftware/clickatell_api_client. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.
