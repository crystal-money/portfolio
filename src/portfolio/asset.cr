module Portfolio
  record Asset, amount : BigDecimal, currency : Money::Currency, description : String? = nil do
    include YAML::Serializable

    @[YAML::Field(ignore: true)]
    getter value : Money do
      Money.from_amount(amount, currency)
    end

    @[YAML::Field(ignore: true)]
    getter exchanged : Money do
      value.exchange_to(Money.default_currency)
    end
  end
end
