class Xmkr
  COINS=[25,5,10,5,1]

  class << self
    def greedy(amt)
      coins = COINS.dup.sort.reverse
      coins.map do |coin|
        puts coin
        num_coins = amt / coin
        amt %= coin
        Array.new(num_coins){coin}
      end.flatten
    end
  end
end


RSpec.describe Xmkr do
  it 'is greedy' do
    expect(Xmkr.greedy(100)).to eq([25,25,25,25])
    expect(Xmkr.greedy(38)).to eq([25,25,25,25])
  end

  it 'is efficient' do
  end

end
