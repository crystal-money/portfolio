module Portfolio
  class Config
    include YAML::Serializable

    # Filepath to currency rates cache.
    CURRENCY_RATES_FILEPATH =
      Path[Dir.tempdir] / "portfolio" / ".cache" / "currency_rates.json"

    # Initializes currency rates cache.
    def self.init_currency_rates_cache! : Nil
      Dir.mkdir_p(CURRENCY_RATES_FILEPATH.dirname)
    end

    # Clears currency rates cache.
    def self.clear_currency_rates_cache! : Bool
      File.delete?(CURRENCY_RATES_FILEPATH)
    end

    # Currency rate store to use.
    @[YAML::Field(ignore: true)]
    getter rate_store : Money::Currency::RateStore do
      if ttl = currency_rates_ttl
        Money::Currency::RateStore::File.new(
          filepath: CURRENCY_RATES_FILEPATH,
          ttl: ttl,
        )
      else
        Money::Currency::RateStore::Memory.new
      end
    end

    # Rate provider used for currency exchange.
    @[YAML::Field(converter: Money::Currency::RateProvider::Converter)]
    getter rate_provider : Money::Currency::RateProvider

    # Time to live (TTL) for currency rates, `nil` means unlimited TTL.
    @[YAML::Field(converter: Time::Span::Converter)]
    getter currency_rates_ttl : Time::Span?

    # Currency used for asset values.
    getter currency : Money::Currency

    # Name of the portfolio.
    getter name : String?

    # Array of assets to track.
    getter assets : Array(Asset)

    # Total value of `assets` represented in `currency`.
    def assets_total : Money
      assets.sum(&.exchanged)
    end

    private def after_initialize
      Config.init_currency_rates_cache!
    end
  end
end
