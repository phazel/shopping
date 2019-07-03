require 'pry'

class Checkout

  PRICES = {
    vga: 30
  }

  def initialize()
    @total = 0
  end

  def scan(sku)
    if PRICES.key? sku
      @total += PRICES[sku]
    end
  end

  def total
    @total
  end
end
