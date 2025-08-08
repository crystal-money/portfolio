require "log"
require "option_parser"
require "./portfolio"

Log.setup_from_env

currency_rates_filepath =
  Path[Dir.tempdir] / "portfolio" / ".cache" / "currency_rates.json"

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

# ameba:disable Lint/NotNil
config = File.open(config_path.not_nil!) do |file|
  Portfolio::Config.from_yaml(file)
end

Money.configure do |context|
  context.default_currency = config.currency
  context.default_rate_store =
    Money::Currency::RateStore::File.new(
      filepath: currency_rates_filepath,
      ttl: config.currency_rates_ttl,
    )
  context.default_rate_provider = config.rate_provider
end

renderer = Portfolio::Renderer.new(config)
renderer.render
