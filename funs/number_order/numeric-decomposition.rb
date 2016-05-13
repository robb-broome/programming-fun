require 'rspec'
require 'pry'
class Decomposer
  attr_reader :num, :split
  def initialize num
    @num = num
    @split   = num.to_s.split //
  end

  def sig_power
    10 ** (split.length - 1)
  end

  def unshift
    power = sig_power
    top_digit = split.shift.to_i
    value = top_digit * power
    [value, num % value]
  end
end

RSpec.describe Decomposer do

  describe 'sig_value' do
    it { expect(Decomposer.new(2222).sig_power).to eq 1000 }
    it { expect(Decomposer.new(9999).sig_power).to eq 1000 }
    it { expect(Decomposer.new(99_999).sig_power).to eq 10000 }
  end

  describe 'unshift highest order' do
    it { expect(Decomposer.new(1234).unshift).to eq [1000, 234]}
    it { expect(Decomposer.new(1).unshift).to eq [1, 0]}
  end
end
