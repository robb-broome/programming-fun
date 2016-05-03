require 'rspec'

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
      prev_place = ''
      ''.tap do |result|
        PLACES.each do |rule|
          current_tens, current_place = rule
          val, number = number.divmod(current_tens)
          puts "#{current_tens}, #{val}, #{number}"
          romans = current_place * val
          if romans.length == 4
            romans = current_place + prev_place
          end
          prev_place = current_place
          result << romans
        end
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
