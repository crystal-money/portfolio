module Portfolio
  record Asset, value : Money, exchanged : Money? = nil, description : String? = nil do
    getter exchanged : Money do
      value.exchange_to(Money.default_currency)
    end
  end
end
