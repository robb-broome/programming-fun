require 'rspec'
require 'pry'

def is_happy(num, cycle = [])
  return false if cycle.include?(num)
  return true if num == 1
  digits = num.to_s.split('').map(&:to_i)
  puts cycle.join(',')
  is_happy(digits.map {|digit| digit ** 2}.sum, cycle << num)
end


RSpec.describe 'happy' do 
  subject(:happy) { is_happy(num) }

  context 'when the number cycles but does not reduce to 1' do
    let(:num) { 99 }
    it 'is not happy' do
      expect(happy).not_to be_truthy
    end
  end
  context 'when the number reduces to 1' do
    let(:num) { 82 }
    it 'is happy' do
      expect(happy).to be_truthy
    end
  end
end
