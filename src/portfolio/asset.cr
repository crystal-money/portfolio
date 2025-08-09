module Portfolio
  record Asset, amount : BigDecimal, currency : Money::Currency, description : String? = nil do
    include YAML::Serializable

    # Returns value of this asset as a `Money` object made from `amount` and `currency`.
    @[YAML::Field(ignore: true)]
    getter value : Money do
      Money.from_amount(amount, currency)
    end

    # Returns `value` exchanged to `Money.default_currency`.
    @[YAML::Field(ignore: true)]
    getter exchanged : Money do
      value.exchange_to(Money.default_currency)
    end
  end
end
