require 'checkout'

describe Checkout do
  let(:co) { described_class.new }

  it 'can purchase a VGA adapter' do
    co.scan(:vga)
    expect(co.total).to eq 30
  end

  it 'can purchase one of each product' do
    co.scan(:ipd)
    co.scan(:mbp)
    co.scan(:atv)
    co.scan(:vga)
    expect(co.total).to eq 2089.48
  end
end
