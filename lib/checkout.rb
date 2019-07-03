class Checkout

  PRICES = {
    ipd: 549.99,
    mbp: 1399.99,
    atv: 109.50,
    vga: 30.00
  }

  def initialize()
    @total = 0
  end

  def scan(sku)
    @total += PRICES[sku] if PRICES.key? sku
  end

  def total
    @total
  end
end
