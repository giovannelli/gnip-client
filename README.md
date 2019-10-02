# Gnip Client
Gnip client is a Ruby library for accessing the Gnip API, with this gem you can manage rules, full archive search, and streaming realtime contents. 
You can also call the replay method if the realtimestream goes down for any reason.

In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/gnip`. 
To experiment with that code, run `bundle console` for an interactive prompt.



## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gnip-client', require: 'gnip'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gnip-client

## Usage
You can define the client passing username, password, account and label (defaul is dev).

```ruby
label possible values: prod, dev
client = Gnip::PowerTrackClient.new(username: YOUR_USERNAME, password: YOUR_PASSWORD, account: YOUR_ACCOUNT, label: "prod")
```

**Manage gnip rules**

```ruby
rules = {"rules": [{"value": "rule1", "tag": "tag1"}, {"value":"rule2"}] }

client.rules.add(rules)
client.rules.remove(rules)
client.rules.list
client.rules.delete_all!

#For the replay channel
client.replay_rules.add(rules)
client.replay_rules.remove(rules)
client.replay_rules.list
client.replay_rules.delete_all!

```

**Full Archive search**

```ruby
client.full_archive.search(query: "hello", date_from: 2.months.ago, date_to: 20.hours.ago)
client.full_archive.total_by_time_period(query: "hello", date_from: 2.months.ago, date_to: 20.hours.ago)
client.full_archive.total(query: "hello", date_from: 2.months.ago, date_to: 20.hours.ago)
```

**30day search**

```ruby
client.thirty_day.search(query: "hello", date_from: 30.days.ago, date_to: 1.hour.ago)
client.thirty_day.total_by_time_period(query: "hello", date_from: 30.days.ago, date_to: 1.hour.ago)
client.thirty_day.total(query: "hello", date_from: 30.days.ago, date_to: 1.hour.ago)
```

**Stream**

Derived from [gnip-stream](https://github.com/rweald/gnip-stream)

```ruby
client.stream.consume(date_from: Time.now - 2.days, date_to: Time.now - 1.day) do |data|
  puts data
end

client.replay.consume(date_from: Time.now - 2.days, date_to: Time.now - 1.day) do |data|
  puts data
end

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/giovannelli/gnip-client/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
