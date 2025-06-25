require "log"

require "./portfolio"

Log.setup_from_env

Portfolio::CLI.run
