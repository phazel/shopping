require 'bigdecimal'

class Checkout

  PRICES = {
    ipd: BigDecimal("549.99"),
    mbp: BigDecimal("1399.99"),
    atv: BigDecimal("109.50"),
    vga: BigDecimal("30.00")
  }

  def initialize(pricing_rules)
    @pricing_rules = pricing_rules
    @scanned = []
  end

  def scan(sku)
    raise SKUError.new "SKU does not exist" if !PRICES.key? sku
    @scanned << sku
  end

  def total
    calculate.reduce(0) do
      |total, purchase| total += purchase[:price]
    end
  end

  private

  def calculate
    @scanned.map do |sku|
      {
        sku: sku,
        price: PRICES[sku]
      }
    end
  end
end

class SKUError < StandardError
end
