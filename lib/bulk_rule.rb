require 'pry'

class BulkRule
  # for each bulk pricing rule, check if there are more than X many of that sku
  # if there are, replace all their prices.
  def self.apply(rule, scanned)
    if scanned.count { |item| item[:sku] == rule[:sku] } >= rule[:minimum_activation_number]
      scanned = scanned.map do |purchase|
        purchase.merge({ price: rule[:new_price] })
      end
    end
    scanned
  end
end
