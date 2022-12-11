# SimpleRequest

This a ruby gem that abstracts both 'net/http' and 'json'. The goal is to make it easier to make HTTP requests.


## Installation

Add the following line to your Gemfile:

```
gem 'simple_request', git: 'https://github.com/kaiomagalhaes/simple_request.git'
```

## Usage


```
# Get

url = 'https://google.com'
SimpleRequest.get(url)
SimpleRequest.get(url, authorization: 'my-cool-key')
SimpleRequest.get(url, authorization: 'my-cool-key', expect: :json) # when JSON it parses and returns the body.
SimpleRequest.get(url, authorization: 'my-cool-key', expect: :html) # when JSON it parses and returns the html body
SimpleRequest.get(url, authorization: 'my-cool-key', expect: :full) # when JSON it returns the raw response

# Post

url = 'https://google.com'
body = {
  name: 'cool name'
}

SimpleRequest.post(url, body:)
SimpleRequest.post(url, authorization: 'my-cool-key', body:)
SimpleRequest.post(url, authorization: 'my-cool-key', body:, expect: :json) # when JSON it parses and returns the body.
SimpleRequest.post(url, authorization: 'my-cool-key', body: expect: :html) # when JSON it parses and returns the html body
SimpleRequest.post(url, authorization: 'my-cool-key', body: expect: :full) # when JSON it returns the raw response

# Patch

url = 'https://google.com'
body = {
  name: 'cool name',
  id: 1
}

SimpleRequest.patch(url, body:)
SimpleRequest.patch(url, authorization: 'my-cool-key', body:)
SimpleRequest.patch(url, authorization: 'my-cool-key', body:, expect: :json) # when JSON it parses and returns the body.
SimpleRequest.patch(url, authorization: 'my-cool-key', body: expect: :html) # when JSON it parses and returns the html body
SimpleRequest.patch(url, authorization: 'my-cool-key', body: expect: :full) # when JSON it returns the raw response


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kaiomagalhaes/simple_request. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/kaiomagalhaes/simple_request/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SimpleRequest project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/simple_request/blob/main/CODE_OF_CONDUCT.md).
