require 'rspec'
# require_relative 'number_order/numeric-decomposition'

class Roman
    PLACES = [
      [1000, 'M'],
      [500, 'D'],
      [100, 'C'],
      [50, 'L'],
      [10, 'X'],
      [5, 'V'],
      [1, 'I']
    ]
  class << self
    def roman_for number
      return '' if number == 0
      ''.tap do |result|
        PLACES.each_with_index do |rule, index|
          current_tens, current_place = rule
          val, number = number.divmod(current_tens)
          puts "for #{number}: rule:#{rule}, #{val}, #{number}"
          next if val == 0
          if val >= 4
            result << current_place + PLACES[index-1][1]
          elsif val > 0
            result << current_place * val
          end
          break
        end
        return result << Roman.roman_for(number)
      end
    end
  end
end

RSpec.describe Roman do
  describe 'roman_for' do
    it 'turns 4 into IV' do
      expect(Roman.roman_for 4).to eq 'IV'
    end

    it 'turns 3 into III' do
      expect(Roman.roman_for 3).to eq 'III'
    end

    it 'turns 100 into C' do
      expect(Roman.roman_for 100).to eq 'C'
    end

    it 'turns 53 into LIII' do
      expect(Roman.roman_for 53).to eq 'LIII'
    end

    it 'turns 54 into LIV' do
      expect(Roman.roman_for 54).to eq 'LIV'
    end

    it 'turns 2016 into MMXVI' do
      expect(Roman.roman_for 2016).to eq 'MMXVI'
    end

    it 'turns 9 into IX' do
      expect(Roman.roman_for 9).to eq 'IX'
    end

    it 'turns 1989 into MCMDXXXIX' do
      expect(Roman.roman_for 1989).to eq 'MCMDXXXIX'
    end

    it 'turns 90 into XC' do
      expect(Roman.roman_for 90).to eq 'XC'
    end

    it 'turns 900 into CM' do
      expect(Roman.roman_for 900).to eq 'CM'
    end
  end
end
