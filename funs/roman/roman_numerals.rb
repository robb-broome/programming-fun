require 'pry'

class RomanNumerals
  def r_to_a(roman_numeral)
    parts = roman_numeral.split('')
    values = parts.map {|part| value_for(part)}
    len = values.count

    accumulator = 0
    pointer = 0

    while pointer < len
      this_value = values[pointer]
      next_value = values[pointer + 1] || 0
      if this_value < next_value
        # there can be up to one subtractor before a larger number
        # to make '9'
        accumulator += (next_value - this_value)
        pointer += 2
      else
        accumulator += this_value
        pointer += 1
      end
    end
    accumulator
  end

  def value_for(part)
    translation[part]
  end

  def translation
    @translation ||=
      begin
        {
          'I' => 1,
          'V' => 5,
          'X' => 10,
          'L' => 50,
          'C' => 100,
          'D' => 500,
          'M' => 1000,
        }
      end
  end
end


RSpec.describe RomanNumerals do
  subject(:converter) { described_class.new }

  it 'works' do
    expect(converter).to be_a(RomanNumerals)
  end

  describe 'convert roman numerals to arabic' do
    it 'works' do
      expect(converter.r_to_a('XX')).to eq(20)
    end

    it 'converts additively' do
      expect(converter.r_to_a('XXX')).to eq(30)
    end

    it 'converts different amounts' do
      expect(converter.r_to_a('XVI')).to eq(16)
    end

    it 'works for low numbers' do
      expect(converter.r_to_a('III')).to eq(3)
    end

    it 'handles subtractions' do
      expect(converter.r_to_a('IX')).to eq(9)
    end

    it 'handles subtractions' do
      expect(converter.r_to_a('IV')).to eq(4)
    end

    it 'handles subtractions with following additions' do
      expect(converter.r_to_a('MCMXXXII')).to eq(1932)
    end

    it 'handles subtractions with following additions' do
      expect(converter.r_to_a('MCMXXXIX')).to eq(1939)
    end

  end
end
