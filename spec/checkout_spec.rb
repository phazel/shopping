require 'checkout'

describe Checkout do
  let(:co) { described_class.new }

  it 'can purchase a VGA adapter' do
    result = co.scan(:vga)
    expect(co.total).to eq 30
  end
end
