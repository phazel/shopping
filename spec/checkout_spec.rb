require 'checkout'

describe Checkout::Checkout do
  let(:pricing_rules) do
    [
      {
        type: 'BULK',
        sku: :ipd,
        new_price: BigDecimal("499.99"),
        minimum_activation_number: 5
      },
      {
        type: 'RATIO',
        sku: :atv,
        activation_number: 3
      },
      {
        type: 'BUNDLE',
        buy_one: :mbp,
        get_one_free: :vga
      }
    ]
  end
  let(:co) { described_class.new(pricing_rules) }

  it 'can purchase a VGA adapter' do
    co.scan(:vga)
    expect(co.total).to eq BigDecimal("30")
  end

  it 'can purchase one of each product' do
    [:ipd, :mbp, :atv, :vga].each { |sku| co.scan(sku) }
    expect(co.total).to eq BigDecimal("2059.48")
  end

  it "raises an error if the sku doesn't exist" do
    expect { co.scan(:something) }.to raise_error(Checkout::SKUError, "SKU does not exist")
  end

  it 'applies bulk discount if 5 ipads are bought' do
    5.times { co.scan(:ipd) }
    expect(co.total).to eq BigDecimal("2499.95")
  end

  it 'applies ratio discount if 3 apple TVs are bought' do
    3.times { co.scan(:atv) }
    expect(co.total).to eq BigDecimal("219.00")
  end

  it 'applies the bundle deal with Macbook Pro and VGA cable' do
    [:mbp, :vga].each { |sku| co.scan(sku) }
    expect(co.total).to eq BigDecimal("1399.99")
  end

  describe 'example scenarios' do
    context 'when SKUs Scanned: atv, atv, atv, vga' do
      before { [:atv, :atv, :atv, :vga].each { |sku| co.scan(sku) } }
      it { expect(co.total).to eq BigDecimal("249.00") }
    end

    context 'when SKUs Scanned: atv, ipd, ipd, atv, ipd, ipd, ipd' do
      before { [:atv, :ipd, :ipd, :atv, :ipd, :ipd, :ipd].each { |sku| co.scan(sku) } }
      it { expect(co.total).to eq BigDecimal("2718.95") }
    end

    context 'when SKUs Scanned: mbp, vga, ipd' do
      before { [:mbp, :vga, :ipd].each { |sku| co.scan(sku) } }
      it { expect(co.total).to eq BigDecimal("1949.98") }
    end
  end
end
