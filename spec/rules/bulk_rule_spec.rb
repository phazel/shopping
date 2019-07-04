require 'rules/bulk_rule'

describe Checkout::Rules::BulkRule do
  let(:default_price) { BigDecimal("800") }
  let(:discounted_price) { BigDecimal("500") }
  let(:rule) do
    {
      type: 'BULK',
      sku: :ipd,
      new_price: discounted_price,
      minimum_activation_number: 3
    }
  end
  let(:ipd) do
    {
      sku: :ipd,
      price: default_price
    }
  end
  let(:discounted_ipd) { ipd.merge({ price: discounted_price }) }

  describe '.apply' do
    context 'when over the minimum activation number' do
      let(:scanned) { [ipd, ipd, ipd] }
      let(:discounted) { [discounted_ipd, discounted_ipd, discounted_ipd] }
      it { expect(described_class.apply(rule, scanned)).to eq discounted }
    end

    context 'when under the minimum activation number' do
      let(:scanned) { [ipd, ipd] }
      it { expect(described_class.apply(rule, scanned)).to eq scanned }
    end

    context 'when there are other types of items' do
      let(:atv) { { sku: :atv, price: BigDecimal("100") } }
      let(:scanned) { [ipd, ipd, atv, ipd] }
      let(:discounted) { [discounted_ipd, discounted_ipd, atv, discounted_ipd] }
      it { expect(described_class.apply(rule, scanned)).to eq discounted }
    end
  end
end
