# portfolio

Simple command line tool for tracking your assets.

## Installation

```sh
git clone https://github.com/crystal-money/portfolio
cd portfolio

shards install
shards build -Dpreview_mt --release
```

## Usage

### Example configuration file

```yaml
rate_provider:
  name: UniRateAPI
  options:
    api_key: your-api-key

currency_rates_ttl: 15 minutes
currency: EUR

assets:
  -
    amount: 10_000
    currency: USD
    description: Cash
  -
    amount: 13.37
    currency: BTC
    description: Bitcoin in Wallet
```

> [!NOTE]
> Available rate providers can be found at <https://github.com/crystal-money/money/tree/master/src/money/currency/rate_provider>.

### Running

1. Create a `portfolio.yml` file with your configuration
2. Run `./bin/portfolio --config /path/to/portfolio.yml`

## Contributing

1. Fork it (<https://github.com/crystal-money/portfolio/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Sijawusz Pur Rahnama](https://github.com/Sija) - creator and maintainer
