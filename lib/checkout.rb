require 'bigdecimal'

class Checkout

  PRICES = {
    ipd: BigDecimal("549.99"),
    mbp: BigDecimal("1399.99"),
    atv: BigDecimal("109.50"),
    vga: BigDecimal("30.00")
  }

  def initialize()
    @scanned = []
  end

  def scan(sku)
    raise SKUError.new "SKU does not exist" if !PRICES.key? sku
    @scanned << sku
  end

  def total
    @scanned.reduce(0) { |total, sku| total += PRICES[sku] }
  end
end

class SKUError < StandardError
end
