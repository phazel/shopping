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
      }
    ]
  end
  let(:co) { described_class.new(pricing_rules) }

  it 'can purchase a VGA adapter' do
    co.scan(:vga)
    expect(co.total).to eq BigDecimal("30")
  end

  it 'can purchase one of each product' do
    co.scan(:ipd)
    co.scan(:mbp)
    co.scan(:atv)
    co.scan(:vga)
    expect(co.total).to eq BigDecimal("2089.48")
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
end
