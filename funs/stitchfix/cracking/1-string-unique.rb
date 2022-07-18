require 'pry'
# Determine whether a string has all unique characters
#
class BitArray

  attr_accessor :bit_array

  def initialize
    @bit_array = 0
  end

  def exists?(letter)
    value = bit_array & bitwise_ordinal_for(letter)
    value > 0
  end

  def string_unique?(string)
    string.each_char do |letter|
      if exists?(letter)
        return false
      else
        add(letter)
      end
    end
    true
  end

  def bitwise_ordinal_for(letter)
    letter_decimal = letter.ord - base
    1 << letter_decimal
  end

  def add(string)
    string.each_char do |letter|
      self.bit_array = bit_array | bitwise_ordinal_for(letter)
    end
  end

  def show
    puts bit_array
    puts bit_array.class
    puts bit_array.to_s(2)
  end

  def base
    'a'.ord
  end

end

RSpec.describe BitArray do
  let(:ba) { BitArray.new }
  it 'detects unique strings' do
    expect(ba.string_unique?('abcdefg')).to be_truthy
  end

  it 'detects non- unique strings' do
    expect(ba.string_unique?('abcdafg')).to be_falsey
  end

  it 'handles a string' do
    ba.add('fugetabo')
    expect(ba.exists?('i')).to be_falsey
    expect(ba.exists?('o')).to be_truthy
  end

  it 'detects a unique' do
    ba = BitArray.new
    ba.add('f')
    ba.add('a')
    ba.add('z')
    ba.add('m')
    ba.add('o')
    ba.add('r')
    expect(ba.exists?('g')).to be_falsey
  end

  it 'detects a collision' do
    ba = BitArray.new
    ba.add('f')
    ba.add('a')
    ba.add('z')
    ba.add('m')
    expect(ba.exists?('f')).to be_truthy
  end
end
