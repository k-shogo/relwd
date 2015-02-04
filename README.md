# Spinel

[![Gem Version](https://badge.fury.io/rb/spinel.svg)](http://badge.fury.io/rb/spinel)
[![Code Climate](https://codeclimate.com/github/k-shogo/spinel/badges/gpa.svg)](https://codeclimate.com/github/k-shogo/spinel)
[![Test Coverage](https://codeclimate.com/github/k-shogo/spinel/badges/coverage.svg)](https://codeclimate.com/github/k-shogo/spinel)

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
spinel = Spinel.new
spinel.store id: 1, body: 'and all with pearl and ruby glowing'
spinel.store id: 2, body: 'a yellow or orange variety of ruby spinel'
spinel.store id: 3, body: 'a colour called pearl yellow'
spinel.store id: 4, body: 'a mandarin orange net sack'
spinel.store id: 5, body: 'a spinel used as a gemstone usually dark red'
spinel.store id: 6, body: 'today is hotter than usual'
spinel.store id: 7, body: 'call on a person'
spinel.store id: 8, body: 'that gem is shining'
spinel.store id: 9, body: 'polish shoes to a bright shine'
```

データの登録時には最低限の要素として `id` 及び `body` が必要になります。  
ドキュメントの内容を示すキーである `body` は後述する設定によって変更することも可能です。

`score` がキー含まれていた場合は特別に処理されます。  
`score`はドキュメントの優先度を指定できるキーであり、検索結果の順序に関係します。

`id`, `body`, `score` 以外のキーには特殊な処理は行われません、JSONに変換された後、そのまま保存されます。

### 検索 / search

```ruby
spinel = Spinel.new
spinel.search 'ruby'
# => [{"id"=>2, "body"=>"a yellow or orange variety of ruby spinel"}, {"id"=>1, "body"=>"and all with pearl and ruby glowing"}]
spinel.search 'usu'
# => [{"id"=>6, "body"=>"today is hotter than usual"}, {"id"=>5, "body"=>"a spinel used as a gemstone usually dark red"}]
```

### 設定 / Configuration

設定はブロックにより行うことが出来ます。  
以下の例で示されているデフォルト値で運用する場合には設定は必要ありません。

```ruby
Spinel.configure do |config|
  config.redis        = 'redis://127.0.0.1:6379/0'
  config.minimal_word = 2
  config.cache_expire = 600
  config.search_limit = 10
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
spinel.search 'ruby', cache: false, limit: 5
```

#### 名前空間

Spinelは複数階層の名前空間をサポートします。  
SpinelはRedisへのアクセスに `spinel:index:default` のようなキーを用います。  
これを `#{spinel_namespaace}:index:#{index_type}` と見なしたとき、
`#{spinel_namespaace}` 及び `#{index_type}` は変更可能です。

上位の `#{spinel_namespaace}` は configure によって指定可能です。

```
Spinel.configure do |config|
  config.namespace    = 'spinel'
end
```

下位の `#{index_type}` はデータ登録時及び検索時に指定を変更することが可能です。

```
spinel = Spinel.new(:another_type)
```

`#{spinel_namespaace}` よりも上位で名前空間を分割したい場合には [resque/redis-namespace](https://github.com/resque/redis-namespace) を併用してください。

## バージョニング / Versioning

Spinelのバージョニングは[Semantic Versioning 2.0.0](http://semver.org/)に基づいて採番されます。  
現在Spinelは開発初期段階です。  
いつでも、いかなる変更も起こりうります。

## どのように活用できるか

例えばあなたが住所入力のフォームにインクリメンタルサーチを導入しようとしたとき、Spinelは良い選択肢になり得ます。
以下では、[郵便番号データのダウンロード - zipcloud](http://zipcloud.ibsnet.co.jp/)の都道府県データを検索する例を示しています。

この例では、Spinel以外に半角カタカナをひらがなに変換するために[gimite/moji](https://github.com/gimite/moji)ライブラリを使用しています。  
インデキシングさせる情報(`body`キー)には、郵便番号、都道府県及び都道府県の読み仮名を含めており、
データは12万5094件存在します。

```ruby
require 'spinel'
require 'moji'
require 'csv'

header = [
  :jis_x0401, # 全国地方公共団体コード
  :old_code,  # (旧)郵便番号(5桁)
  :code,      # 郵便番号(7桁)
  :pref_kana, # 都道府県名カタカナ
  :city_kana, # 市区町村名カタカナ
  :town_kana, # 町域名カタカナ
  :pref,      # 都道府県名
  :city,      # 市区町村名
  :town,      # 町域名
  :flag1,     # 一町域が二以上の郵便番号で表される場合の表示
  :flag2,     # 小字毎に番地が起番されている町域の表示
  :flag3,     # 丁目を有する町域の場合の表示
  :flag4,     # 一つの郵便番号で二以上の町域を表す場合の表示
  :flag5,     # 更新の表示
  :flag6      # 変更理由
]

import_data = []

puts 'data converting...'
t1 = Time.now
CSV.foreach('x-ken-all.csv') do |row|
  hash = header.zip(row).to_h
  hash[:pref_kana] = Moji.kata_to_hira(Moji.han_to_zen(hash[:pref_kana]))
  hash[:city_kana] = Moji.kata_to_hira(Moji.han_to_zen(hash[:city_kana]))
  hash[:town_kana] = Moji.kata_to_hira(Moji.han_to_zen(hash[:town_kana]))
  doc = {
    id: hash[:code],
    body: [hash[:code], hash[:pref], hash[:city], hash[:town], hash[:pref_kana], hash[:city_kana], hash[:town_kana]].join(' '),
    raw_data: hash
  }
  import_data << doc
end
t2 = Time.now

puts "convert done #{t2 - t1}s"
puts "data importing..."

spinel = Spinel.new
import_data.each do |doc|
  spinel.store doc
end

t3 = Time.now
puts "import done #{t3 - t2}s"

# data converting...
#   convert done 53.303588s
# data importing...
#   import done 188.305489s
```

MacBook Air(1.7 GHz Intel Core i7, 8 GB 1600 MHz DDR3) でデータを投入したとき、
12万件のインポートに約3分かかりました。  
検索には郵便番号、都道府県、読み仮名を組み合わせることが可能で、検索は非常に軽快です。

```ruby
> spinel.search '014'
=> [{"id"=>"0141413",
  "body"=>"0141413 秋田県 大仙市 角間川町 あきたけん だいせんし かくまがわまち", ...

> spinel.search '014 ろくごう'
=> [{"id"=>"0141411",
  "body"=>"0141411 秋田県 大仙市 六郷西根 あきたけん だいせんし ろくごうにしね", ...

> spinel.search 'とうき'
=> [
  {"id"=>"5998242",
  "body"=>"5998242 大阪府 堺市中区 陶器北 おおさかふ さかいしなかく とうききた", ...
  {"id"=>"2892254",
  "body"=>"2892254 千葉県 香取郡多古町 東輝 ちばけん かとりぐんたこまち とうき", ...
  {"id"=>"2080035",
  "body"=>"2080035 東京都 武蔵村山市 中原 とうきょうと むさしむらやまし なかはら", ...

> spinel.search 'とうきょう'
=> [{"id"=>"2080035",
  "body"=>"2080035 東京都 武蔵村山市 中原 とうきょうと むさしむらやまし なかはら", ...

> spinel.search 'とうきょう しぶや'
=> [{"id"=>"1510073",
  "body"=>"1510073 東京都 渋谷区 笹塚 とうきょうと しぶやく ささづか", ...

> spinel.search 'とうきょう しぶや よよぎ'
=> [{"id"=>"1510053",
  "body"=>"1510053 東京都 渋谷区 代々木 とうきょうと しぶやく よよぎ", ...
```

## Contributing

1. Fork it ( https://github.com/k-shogo/spinel/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
