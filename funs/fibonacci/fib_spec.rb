require 'pry'
require 'benchmark'
require 'securerandom'
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

class RecurFib
  attr_accessor :memo, :trace

  def initialize
    @memo = [0,1]
    @trace = Hash.new {|h, k| h[k] = []}
  end

  def fib(n, id: nil)
    id ||= SecureRandom.uuid
    @trace[id] << n
    return @memo[n] if @memo[n]
    @memo[n] = fib(n - 1, id: id) + fib(n - 2, id: id)
  end
end

RSpec.describe RecurFib do
  it 'works' do
    n = 30
    result = 0
    rf = RecurFib.new
    time = Benchmark.realtime do
      result = rf.fib(n)
    end
    puts rf.trace
    puts "The #{n}th fib took #{time} seconds, and is #{result}"
  end
end

class NewFib

  def self.fib(goal, num: 0, seq: [])
    # generate the fib sequence up to this position
    if num > goal
      return seq.last
    elsif seq.count < 2
      seq << 0
      return 0
    else
      fib(goal, num - 1, seq) + fib(goal, num - 2, seq)
    end
  end

end

RSpec.describe NewFib do
  # num is the position in the fibonacci sequence that is desired
  # so fib(3) should return the third number in the sequence

  subject(:fib) { NewFib.method(:fib) }
  specify 'the fb at postition 0 is 0' do
    expect(NewFib.fib(0)).to eq [0]
  end

  specify 'the fib at position 3 is 1' do
    expect(NewFib.fib(3)).to eq([0, 1, 1])
  end
  specify 'the fib at position 10 is 1' do
    time = Benchmark.realtime do
    NewFib.fib(100000)
    end
    puts "The time was #{time}"
    expect(time).to be < 1
  end
end


