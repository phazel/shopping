require 'bigdecimal'

class Checkout

  PRICES = {
    ipd: BigDecimal("549.99"),
    mbp: BigDecimal("1399.99"),
    atv: BigDecimal("109.50"),
    vga: BigDecimal("30.00")
  }

  def initialize()
    @total = BigDecimal("0")
  end

  def scan(sku)
    if PRICES.key? sku
      @total += PRICES[sku]
    else
      raise SKUError.new "SKU does not exist"
    end
  end

  def total
    @total
  end
end

class SKUError < StandardError
end
