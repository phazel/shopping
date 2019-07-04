require 'ratio_rule'

describe Checkout::Rules::RatioRule do
  let(:default_price) { BigDecimal("800") }
  let(:rule) do
    {
      type: 'RATIO',
      sku: :atv,
      activation_number: 3
    }
  end
  let(:atv_base) do
    {
      sku: :atv,
      price: default_price
    }
  end

  def atv
    atv_base.clone
  end

  def discounted_atv
    atv_base.clone.merge({ price: BigDecimal("0") })
  end

  describe '.apply' do
    context 'when you scan enough items' do
      let(:scanned) { [atv, atv, atv, atv, atv, atv, atv] }
      let(:discounted) { [atv, atv, discounted_atv, atv, atv, discounted_atv, atv] }
      it { expect(described_class.apply(rule, scanned)).to eq discounted }
    end

    context "when you haven't scanned enough items" do
      let(:scanned) { [atv, atv] }
      it { expect(described_class.apply(rule, scanned)).to eq scanned }
    end
  end
end
