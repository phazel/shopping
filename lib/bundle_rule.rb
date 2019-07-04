module Checkout
  module Rules
    class BundleRule
      def self.apply(rule, scanned)
        count_buy_ones = count_buy_ones(rule, scanned)

        get_one_free_items(rule, scanned).map.with_index do |item, i|
          if i < count_buy_ones
            item[:price] = BigDecimal("0")
          end
        end

        scanned
      end

      def self.get_one_free_items(rule, scanned)
        scanned.select { |item| item[:sku] == rule[:get_one_free] }
      end

      def self.count_buy_ones(rule, scanned)
        scanned.count { |item| item[:sku] == rule[:buy_one] }
      end
    end
  end
end
