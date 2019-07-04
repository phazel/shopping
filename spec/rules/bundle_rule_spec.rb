require 'rules/bundle_rule'

describe Checkout::Rules::BundleRule do
  let(:rule) do
    {
      type: 'BUNDLE',
      buy_one: :mbp,
      get_one_free: :vga
    }
  end
  let(:mbp) do
    {
      sku: :mbp,
      price: BigDecimal("200")
    }
  end
  let(:vga_base) do
    {
      sku: :vga,
      price: BigDecimal("14")
    }
  end

  def vga
    vga_base.clone
  end

  def free_vga
    vga_base.clone.merge({ price: BigDecimal("0") })
  end

  describe '.apply' do
    context 'when there is one MacBook Pro' do
      let(:scanned) { [mbp] }

      it 'does not add a VGA cable' do
        expect(described_class.apply(rule, scanned)).to eq scanned
      end
    end

    context 'when there is one MacBook Pro and one VGA cable' do
      let(:scanned) { [mbp, vga] }
      let(:discounted) { [mbp, free_vga] }

      it 'makes the VGA cable free' do
        expect(described_class.apply(rule, scanned)).to eq discounted
      end
    end

    context 'when there is one MacBook Pro and two VGA cables' do
      let(:scanned) { [mbp, vga, vga] }
      let(:discounted) { [mbp, free_vga, vga] }

      it 'makes one VGA cable free' do
        expect(described_class.apply(rule, scanned)).to eq discounted
      end
    end

    context 'when there are two MacBook Pros and one VGA cable' do
      let(:scanned) { [mbp, mbp, vga] }
      let(:discounted) { [mbp, mbp, free_vga] }

      it 'makes one VGA cable free' do
        expect(described_class.apply(rule, scanned)).to eq discounted
      end
    end
  end
end
