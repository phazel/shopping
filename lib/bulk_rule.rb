module Checkout
  module Rules
    class BulkRule
      def self.apply(rule, scanned)
        if meets_minimum_number(rule, scanned)
          return replace_prices(rule, scanned)
        end
        scanned
      end

      private

      def self.meets_minimum_number(rule, scanned)
        scanned.count { |item| item[:sku] == rule[:sku] } >= rule[:minimum_activation_number]
      end

      def self.replace_prices(rule, scanned)
        scanned.map do |item|
          item.merge({ price: rule[:new_price] })
        end
      end
    end
  end
end
