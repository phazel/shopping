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
      scanned = @scanned.clone

      @pricing_rules.each do |rule|
        case rule[:type]
        when 'BULK'
          scanned = BulkRule.apply(rule, scanned)
        when 'RATIO'
          scanned = RatioRule.apply(rule, scanned)
        when 'BUNDLE'
          scanned = BundleRule.apply(rule, scanned)
        end
      end

      scanned
    end
  end

  class SKUError < StandardError
  end
end
