class BulkRule
  # for each bulk pricing rule, check if there are more than X many of that sku
  # if there are, replace all their prices.
  def self.apply(rule, scanned)
    if meets_minimum_number(rule, scanned)
      scanned = replace_prices(rule, scanned)
    end
    scanned
  end

  private

  def self.meets_minimum_number(rule, scanned)
    scanned.count { |item| item[:sku] == rule[:sku] } >= rule[:minimum_activation_number]
  end

  def self.replace_prices(rule, scanned)
    scanned.map do |purchase|
      purchase.merge({ price: rule[:new_price] })
    end
  end
end
