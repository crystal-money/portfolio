module Portfolio
  class Config
    include YAML::Serializable

    # Rate store used for currency exchange.
    @[YAML::Field(converter: Money::Currency::RateStore::Converter)]
    property rate_store : Money::Currency::RateStore do
      Money.default_rate_store
    end

    # Rate provider used for currency exchange.
    @[YAML::Field(converter: Money::Currency::RateProvider::Converter)]
    property rate_provider : Money::Currency::RateProvider

    # Currency used for asset values.
    property currency : Money::Currency

    # Name of the portfolio.
    property name : String?

    # Array of assets to track.
    property assets : Array(Asset)

    # Total value of `assets` represented in `currency`.
    def assets_total : Money
      assets.sum(&.exchanged)
    end
  end
end
