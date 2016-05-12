require 'rspec'
require 'pry'
class Decomposer
  attr_reader :num
  def initialize num
    @num = num
  end
  def unshift
    subject = num.to_s.split //
    power = 10 ** (subject.length - 1)
    value = subject.shift.to_i * power
    [value, num % value]
  end
end

RSpec.describe Decomposer do

  describe 'unshift highest order' do
    describe 'thousands' do
      subject {Decomposer.new(1234).unshift }
      it { is_expected.to eq [1000, 234] }
    end
    describe 'single' do

      subject {Decomposer.new(1).unshift }
      it { is_expected.to eq [1, 0] }
    end
  end
end
