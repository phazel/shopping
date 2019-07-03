require 'bigdecimal'

include Checkout::Rules

module Checkout
  class Checkout
    PRICES = {
      ipd: BigDecimal("549.99"),
      mbp: BigDecimal("1399.99"),
      atv: BigDecimal("109.50"),
      vga: BigDecimal("30.00")
    }.freeze

    def initialize(pricing_rules)
      @pricing_rules = pricing_rules
      @scanned = []
    end

    def scan(sku)
      raise SKUError.new "SKU does not exist" if !PRICES.key? sku
      @scanned << {
        sku: sku,
        price: PRICES[sku]
      }
    end

    def total
      adjusted_prices.reduce(0) do
        |total, purchase| total += purchase[:price]
      end
    end

    private

    def adjusted_prices
      @pricing_rules.reduce(@scanned) do |adjusted, rule|
        case rule[:type]
        when 'BULK'
          BulkRule.apply(rule, adjusted)
        end
      end
    end
  end

  class SKUError < StandardError
  end
end
