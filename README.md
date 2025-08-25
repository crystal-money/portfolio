# Portfolio [![CI](https://github.com/crystal-money/portfolio/actions/workflows/ci.yml/badge.svg)](https://github.com/crystal-money/portfolio/actions/workflows/ci.yml) [![Releases](https://img.shields.io/github/release/crystal-money/portfolio.svg)](https://github.com/crystal-money/portfolio/releases) [![License](https://img.shields.io/github/license/crystal-money/portfolio.svg)](https://github.com/crystal-money/portfolio/blob/master/LICENSE)

Simple command line tool for tracking your assets (metals, fiat and crypto).

## Installation

```sh
git clone https://github.com/crystal-money/portfolio.git
cd portfolio

shards install
shards build --release
```

## Usage

### Example configuration file

> [!NOTE]
> Available rate providers can be found at <https://github.com/crystal-money/money/tree/master/src/money/currency/rate_provider>.

```yaml
rate_provider:
  name: Compound
  options:
    providers:
      - name: FloatRates
      - name: UniRateAPI
        options:
          api_key: your-api-key

currency_rates_ttl: 15 minutes
currency: EUR

assets:
  - amount: 10_000.11
    currency: USD
    description: Cash under the mattress

  - amount: 13.37
    currency: BTC
    description: Bitcoin in the wallet

  - amount: 4107
    currency: ETH
    description: Ethereum investment
```

<img width="622" height="164" alt="Screenshot" src="https://github.com/user-attachments/assets/83ccd298-ebfa-4a7d-94f9-ad94fb822896" />

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
