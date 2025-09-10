require "log"
require "option_parser"
require "./portfolio"

DEFAULT_CONFIG_PATH =
  Path["~", ".config", "portfolio", "config.yml"].expand(home: true)

Log.setup_from_env

clear_currency_rates_cache = false
config_path =
  if File.exists?(DEFAULT_CONFIG_PATH)
    DEFAULT_CONFIG_PATH
  end

option_parser = OptionParser.new do |parser|
  parser.banner = "Usage: portfolio [arguments]"

  parser.on("-c PATH", "--config=PATH", "Path to config file") do |path|
    config_path = Path[path].expand(home: true) if path.presence
  end
  parser.on("-x", "--clear-cache", "Clear currency rates cache") do
    clear_currency_rates_cache = true
  end
  parser.on("-v", "--version", "Print version") do
    puts Portfolio::VERSION
    exit(0)
  end
  parser.on("-h", "--help", "Show this help") do
    puts parser
    exit(0)
  end
  parser.invalid_option do |flag|
    STDERR.puts "ERROR: #{flag} is not a valid option".colorize(:red)
    STDERR.puts parser
    exit(1)
  end
end

option_parser.parse

unless config_path
  abort option_parser
end

begin
  # ameba:disable Lint/NotNil
  config = File.open(config_path.not_nil!) do |file|
    Portfolio::Config.from_yaml(file)
  end

  if clear_currency_rates_cache
    config.rate_store.clear
  end

  Money.configure do |context|
    context.default_currency = config.currency
    context.default_rate_store = config.rate_store
    context.default_rate_provider = config.rate_provider
  end

  renderer = Portfolio::Renderer.new
  renderer.render(config)
rescue ex
  abort "ERROR: #{ex.message}".colorize(:red)
end
