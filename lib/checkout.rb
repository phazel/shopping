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
      calculate.reduce(0) do
        |total, purchase| total += purchase[:price]
      end
    end

    private

    def calculate
      altered_scanned = []

      @pricing_rules.each do |rule|
        case rule[:type]
        when 'BULK'
          altered_scanned = BulkRule.apply(rule, @scanned)
        end
      end

      altered_scanned
    end
  end

  class SKUError < StandardError
  end
end
