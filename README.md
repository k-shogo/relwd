# Spinel

Spinel is Redis based lightweight text search engine.  
SpinelはRedisをバックエンドに用いた軽量なテキスト検索システムです。

## コンセプト

Spinelはテキスト検索システムですが、余計なことはいたしません。  
形態素解析やストップワードの除去などはSpinelよりも上位の層で行う必要があります。  
大規模な全文検索を行う場合にはSolrやElasticsearchの使用を検討してください。

## インストール / Installation

Add this line to your application's Gemfile:

```ruby
gem 'spinel'
```

And then execute:

```shell
$ bundle
```

Or install it yourself as:

```shell
$ gem install spinel
```

## 使い方 / Usage

### データ登録 / registration

```ruby
backend = Spinel.backend
backend.add id: 1, body: 'and all with pearl and ruby glowing'
backend.add id: 2, body: 'a yellow or orange variety of ruby spinel'
backend.add id: 3, body: 'a colour called pearl yellow'
backend.add id: 4, body: 'a mandarin orange net sack'
backend.add id: 5, body: 'a spinel used as a gemstone usually dark red'
backend.add id: 6, body: 'today is hotter than usual'
backend.add id: 7, body: 'call on a person'
backend.add id: 8, body: 'that gem is shining'
backend.add id: 9, body: 'polish shoes to a bright shine'
```

データの登録時には最低限の要素として `id` 及び `body` が必要になります。  
ドキュメントの内容を示すキーである `body` は後述する設定によって変更することも可能です。

`score` がキー含まれていた場合は特別に処理されます。  
`score`はドキュメントの優先度を指定できるキーであり、検索結果の順序に関係します。

### 検索 / search

```ruby
matcher = Spinel.matcher
matcher.matches 'ruby'
# => [{"id"=>2, "body"=>"a yellow or orange variety of ruby spinel"}, {"id"=>1, "body"=>"and all with pearl and ruby glowing"}]
matcher.matches 'usu'
# => [{"id"=>6, "body"=>"today is hotter than usual"}, {"id"=>5, "body"=>"a spinel used as a gemstone usually dark red"}]
```

### 設定 / Configuration

設定はブロックにより行うことが出来ます。  
以下の例で示されているデフォルト値で運用する場合には設定は必要ありません。

```ruby
Spinel.configure do |config|
  config.redis        = 'redis://127.0.0.1:6379/0'
  config.min_complete = 2
  config.cache_expire = 600
  config.match_limit  = 10
  config.document_key = :body
  config.namespace    = 'spinel'
end
```

#### redisの接続先

デフォルトでは `redis://127.0.0.1:6379/0` に接続しようとします。  
環境変数に `REDIS_URL` が存在するとき、`redis://127.0.0.1:6379/0` よりも優先してその値を使おうとします。  
明示的な設定が行われた場合には環境変数よりも設定が優先されます。

明示的な設定において文字列が与えられた場合には、文字列をパースしてredisの接続を作成します。  
[resque/redis-namespace](https://github.com/resque/redis-namespace)等を使いたい場合には、直接指定することも可能です。

```ruby
Spinel.configure do |config|
  config.redis = Redis::Namespace.new(:ns, redis: Redis.new)
end
```

#### 検索結果のキャッシュ / 候補数

高速化の為に、同一のクエリーの検索結果は最後の検索から10分間キャッシュされます。  
`config.cache_expire` はキャッシュの有効期限を設定する項目です。  
また `config.match_limit` はデフォルトの検索候補の最大数を変更します。

キャッシュの使用と検索候補数は検索時にオプションとして値を指定することも可能です。

```ruby
matcher.matches 'ruby', cache: false, limit: 5
```


## Contributing

1. Fork it ( https://github.com/k-shogo/spinel/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
