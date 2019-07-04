module Checkout
  module Rules
    class BundleRule
      def self.apply(rule, scanned)
        # for however many MBPs there are, make that many VGAs free
        number_of_buy_ones = scanned.count { |item| item[:sku] == rule[:buy_one] }

        get_one_free_items = scanned.select { |item| item[:sku] == rule[:get_one_free] }

        get_one_free_items.map.with_index do |item, i|
          if i < number_of_buy_ones
            item[:price] = BigDecimal("0")
          end
        end

        scanned
      end
    end
  end
end
