require "yaml"

module Portfolio
  class Data
    getter rate_provider : Money::Currency::RateProvider

    getter currency_rates_ttl : Time::Span?
    getter currency : Money::Currency
    getter assets : Array(Asset)

    def initialize(filepath : Path)
      data = YAML.parse(File.read(filepath)).as_h

      rate_provider = data["rate_provider"].as_h
      rate_provider_name = rate_provider["name"].as_s
      rate_provider_options = rate_provider["options"].as_h.to_h do |key, value|
        {key.as_s, value.raw}
      end
      @rate_provider = Money::Currency::RateProvider.build(
        name: rate_provider_name,
        options: rate_provider_options,
      )

      if ttl = data["currency_rates_ttl"]?.try(&.as_s.presence)
        @currency_rates_ttl = Time::Span.parse(ttl)
      end
      @currency = Money::Currency.find(data["currency"].as_s)
      @assets = data["assets"].as_a.map do |asset|
        Asset.new(
          value: Money.from_amount(
            asset["amount"].to_s,
            asset["currency"].as_s,
          ),
          description: asset["description"]?.try(&.as_s.presence),
        )
      end
    end

    def assets_total : Money
      assets.sum(&.exchanged)
    end
  end
end
