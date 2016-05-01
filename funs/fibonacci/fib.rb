require 'benchmark'
class Ans
  MEMO = {}
end
class Fib
  NUM = [0,1,1,2,3,5,8,13,21,34]
  IDX = [0,1,2,3,4,5,6, 7, 8, 9]
  class << self
    def index num
      memo = Ans::MEMO[num]
      return memo if memo
      if num < 2
        Ans::MEMO[num] = num
      else
        Ans::MEMO[num] = Fib.index(num -1) + Fib.index(num - 2)
      end
    end
    end
  end

RSpec.describe Fib do
  it 'generates the nth fibonacci number' do
    expect(Fib.index(4)).to eq 3
    expect(Fib.index(5)).to eq 5
    expect(Fib.index(6)).to eq 8
  end

  it 'makes a series' do
    series = [].tap do |ans|
      10.times do |index|
        ans << Fib.index(index)
      end
    end
    expect(series).to eq(Fib::NUM)
  end

  it 'can do big ones' do
    puts Fib.index(25)
  end
end
