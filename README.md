# Gnip

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/gnip`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gnip'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gnip

## Usage

client = Gnip::PowerTrackClient.new(username: YOUR_USERNAME, password: YOUR_PASSWORD, account: YOUR_ACCOUNT, label: "prod")

label possible values: prod, dev

client.rules.add(rules)
client.rules.remove(rules)
client.rules.list
client.rules.delete_all

client.full_archive.counts(query: "ciao", date_from: Time.now - 2.months, date_to: Time.now - 20.hours)
client.full_archive.counts(query: "ciao", date_from: Time.now - 2.months, date_to: Time.now - 20.hours)

client.stream.consume(date_from: Time.now - 2.day, date_to: Time.now - 1.day) do |data|
  puts data
end

client.replay.consume(date_from: Time.now - 2.day, date_to: Time.now - 1.day) do |data|
  puts data
end

client.full_archive.counts(query: "ciao", date_from: Time.now - 2.months, date_to: Time.now - 20.hours)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/gnip/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
