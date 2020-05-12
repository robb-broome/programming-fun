require 'pry'
class IsItPrime
  def prime?(num)
    return false if num % 2 == 0
    return true if num == 1
    midpoint = Math.sqrt(num).to_i
    midpoint.downto(2) do |test|
      STDOUT.print '.'
      return false if num % test == 0
    end
    true
  end
end
RSpec.describe IsItPrime do
  subject(:prime) { IsItPrime.new }
  let(:cases) do
    { 1 => true,
      2 => false,
      5 => true,
      7 => true,
      19 => true,
      21 => false,
      982_451_653 => true,
      899_809_343 => true,
      2618163402417*(2**1290000)-1 => true
    }
  end

  it 'works' do
    cases.each do |test, expected_outcome|
      STDOUT.print ", #{test}"
      outcome = prime.prime?(test)
      puts 
      expect(outcome).to eq(expected_outcome)
    end
  end
end
