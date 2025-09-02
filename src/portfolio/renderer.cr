require "colorize"
require "tallboy"

module Portfolio
  class Renderer
    def initialize(@io = STDOUT)
    end

    def render(config : Config) : Nil
      table = Tallboy.table do
        if name = config.name
          header do
            cell name, span: 4, align: :center
          end
        end
        header do
          cell "Description"
          cell "Currency"
          cell "Value"
          cell "Exchanged (%s)" % Money.default_currency, align: :right
        end
        config.assets.each do |asset|
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
          cell config.assets_total.format(no_cents_if_whole: true).colorize(:light_red)
        end
      end
      @io.puts table.render
    end
  end
end
