require 'checkout'

describe Checkout do
  let(:co) { described_class.new }

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
    expect { co.scan(:something) }.to raise_error(SKUError, "SKU does not exist")
  end
end
