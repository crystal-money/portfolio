require "colorize"
require "tallboy"

module Portfolio
  class Renderer
    def initialize(@config : Config, @io = STDOUT)
    end

    def render : Nil
      table = Tallboy.table do
        columns do
          add "Description"
          add "Currency"
          add "Value"
          add "Exchanged (%s)" % Money.default_currency, align: :right
        end
        header
        @config.assets.each do |asset|
          row [
            asset.description.colorize(:white),
            "%s (%s)".colorize(:light_blue).to_s % {
              asset.value.currency.name,
              asset.value.currency.code,
            },
            asset.value.format(drop_trailing_zeros: true).colorize(:dark_gray),
            asset.exchanged.format(no_cents_if_whole: true).colorize(:green),
          ]
        end
        footer do
          cell "Total", span: 3
          cell @config.assets_total.format(no_cents_if_whole: true).colorize(:light_red)
        end
      end
      @io.puts table.render
    end
  end
end
