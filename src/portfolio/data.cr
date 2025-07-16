module Portfolio
  class Data
    include YAML::Serializable

    @[YAML::Field(converter: Money::Currency::RateProvider::Converter)]
    getter rate_provider : Money::Currency::RateProvider

    @[YAML::Field(converter: Time::Span::Converter)]
    getter currency_rates_ttl : Time::Span?
    getter currency : Money::Currency
    getter assets : Array(Asset)

    def assets_total : Money
      assets.sum(&.exchanged)
    end
  end
end
