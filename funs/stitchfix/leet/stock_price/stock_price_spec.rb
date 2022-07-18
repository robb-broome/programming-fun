require 'rspec'
require 'pry'

def max_profit(prices)
  buy_pointer = 0
  sell_pointer = 1
  count = prices.count
  profit = 0

  while sell_pointer < count && buy_pointer < count - 2
    buy_price = prices[buy_pointer]
    puts [buy_price, buy_pointer, sell_pointer].join ', '

    while sell_pointer < count - 1
      proposed_sell_price = prices[sell_pointer]
      puts "proposed sell: #{proposed_sell_price}"
      next_price = prices[sell_pointer + 1] || 0
      if proposed_sell_price > buy_price && buy_price > next_price
        puts 'a sale'
        profit += proposed_sell_price
        buy_pointer = sell_pointer
        break
      end
      sell_pointer += 1
    end
    buy_pointer += 1
  end
  profit
end

RSpec.describe 'max_profit' do
  context 'when prices are variable' do
    let(:prices) { [7,1,5,3,6,4] }
    specify 'profit is not zero' do
      expect(max_profit(prices)).to eq(7)
    end
  end
  context 'when prices are monotonically falling' do
    let(:prices) { [7,6,4,3,1] }
    specify 'profit is zero' do
      expect(max_profit(prices)).to eq(0)
    end
  end
end
