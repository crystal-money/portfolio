module Portfolio
  class Config
    include YAML::Serializable

    # Rate provider used for currency exchange.
    @[YAML::Field(converter: Money::Currency::RateProvider::Converter)]
    getter rate_provider : Money::Currency::RateProvider

    # Time to live (TTL) for currency rates, `nil` means unlimited TTL.
    @[YAML::Field(converter: Time::Span::Converter)]
    getter currency_rates_ttl : Time::Span?

    # Currency used for asset values.
    getter currency : Money::Currency

    # Array of assets to track.
    getter assets : Array(Asset)

    # Total value of `assets` represented in `currency`.
    def assets_total : Money
      assets.sum(&.exchanged)
    end
  end
end
