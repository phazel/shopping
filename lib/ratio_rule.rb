module Checkout
  module Rules
    class RatioRule
      def self.apply(rule, scanned)
        scanned.select { |item| item[:sku] == rule[:sku] }.map.with_index do |item, i|
          if i % rule[:activation_number] == rule[:activation_number] - 1
            item[:price] = BigDecimal("0")
          end
        end
        scanned
      end
    end
  end
end
