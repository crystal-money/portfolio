module Portfolio
  class Config
    include YAML::Serializable

    # Currency exchange to use.
    property exchange : Money::Currency::Exchange

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
