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
    scanned = @scanned.map do |sku|
      {
        sku: sku,
        price: PRICES[sku]
      }
    end

    # for each bulk pricing rule, check if there are more than X many of that sku
    # if there are, replace all their prices.
    @pricing_rules.select { |rule| rule[:type] == 'BULK' }.each do |bulk_rule|
      if @scanned.select { |sku| sku == bulk_rule[:sku] }.length >= bulk_rule[:minimum_activation_number]
        scanned = scanned.map do |purchase|
          purchase.merge({ price: bulk_rule[:new_price] })
        end
      end
    end

    scanned
  end
end

class SKUError < StandardError
end
