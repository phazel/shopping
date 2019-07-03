require 'checkout'

describe Checkout do
  let(:co) { described_class.new }

  it { expect(co.total).to eq 4 }
end
