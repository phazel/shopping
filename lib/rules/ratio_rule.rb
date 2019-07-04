module Checkout
  module Rules
    class RatioRule
      def self.apply(rule, scanned)
        relevant_items(rule, scanned).map.with_index do |item, i|
          if item_needs_discount(rule, i)
            item[:price] = BigDecimal("0")
          end
        end
        scanned
      end

      private

      def self.relevant_items(rule, scanned)
        scanned.select { |item| item[:sku] == rule[:sku] }
      end

      def self.item_needs_discount(rule, i)
        i % rule[:activation_number] == rule[:activation_number] - 1
      end
    end
  end
end
