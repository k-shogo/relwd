# Relwd

RelwdはRedisをバックエンドに用いた軽量なサジェストシステムです。

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'relwd'
```

And then execute:

```shell
$ bundle
```

Or install it yourself as:

```shell
$ gem install relwd
```

## Usage

### Configuration

```ruby
Relwd.configure do |config|
  config.redis = 'redis://127.0.0.1:6379/0'
  config.min_complete = 3
  config.cache_expire = 300
end
```

## Contributing

1. Fork it ( https://github.com/k-shogo/relwd/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
