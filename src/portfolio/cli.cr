require "option_parser"

module Portfolio
  class CLI
    property currency_rates_filepath =
      Path[Dir.tempdir] / "portfolio" / ".cache" / "currency_rates.json"

    def self.run
      new.run
    end

    def run
      clear_currency_rates_cache = false
      config_path = nil

      option_parser = OptionParser.new do |parser|
        parser.banner = "Usage: portfolio [arguments]"

        parser.on("-c PATH", "--config=PATH", "Path to config file") do |path|
          config_path = Path[path]
        end
        parser.on("-x", "--clear-cache", "Clear currency rates cache") do
          clear_currency_rates_cache = true
        end
        parser.on("-h", "--help", "Show this help") do
          puts parser
          exit(0)
        end
        parser.invalid_option do |flag|
          STDERR.puts "ERROR: #{flag} is not a valid option."
          STDERR.puts parser
          exit(1)
        end
      end

      option_parser.parse

      if clear_currency_rates_cache
        File.delete?(currency_rates_filepath)
      end

      unless config_path
        if clear_currency_rates_cache
          exit(0)
        else
          STDERR.puts option_parser
          exit(1)
        end
      end

      Dir.mkdir_p(currency_rates_filepath.dirname)

      data =
        Data.new(config_path.not_nil!) # ameba:disable Lint/NotNil

      setup_defaults(data)

      renderer = Renderer.new(data)
      renderer.render
    end

    protected def setup_defaults(data : Data) : Nil
      Money.default_currency = data.currency

      Money.default_rate_store =
        Money::Currency::RateStore::File.new(
          filepath: currency_rates_filepath,
          ttl: data.currency_rates_ttl,
        )
      Money.default_rate_provider = data.rate_provider
    end
  end
end
