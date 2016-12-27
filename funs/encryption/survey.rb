require 'pry'
class Caesar
  A = 'a'.sum
  BASE = A - 1
  Z = 'z'.sum
  DEFAULT_SHIFT = 1
  ALPHABET_SIZE = 26
  ENCODING = 'US-ASCII'

  class << self

    def encypher(word, shift_by = DEFAULT_SHIFT)
      shift_word(word, shift_by)
    end

    def decypher(word, shift_by = DEFAULT_SHIFT)
      shift_word(word, shift_by * -1)
    end

    def shift(letter, shift_by)
      position = (letter.sum % BASE)
      shifted_position = ((position + shift_by) % ALPHABET_SIZE)
      shifted_position = shifted_position == 0 ? ALPHABET_SIZE : shifted_position
      shifted = shifted_position + BASE
      shifted.chr ENCODING
    end

    def shift_word(word, shift_by)
      word.split('').map {|letter| shift(letter, shift_by) }.join
    end

  end
end

RSpec.describe Caesar do

  context 'shift by default value' do
    let(:word) { 'abcde' }
    let(:cypher) { 'bcdef' }

    let(:wrapword) { 'wxyz' }
    let(:wrapcypher) { 'xyza' }

    it 'shifts' do
      expect(Caesar.shift('a', 1)).to eq('b')
    end

    it 'shifts left' do
      expect(Caesar.shift('b', -1)).to eq('a')
    end

    it 'shifts left and rotaates' do
      expect(Caesar.shift('a', -1)).to eq('z')
    end

    it 'decyphers a' do
      expect(Caesar.decypher('a')).to eq('z')
    end

    it 'encyphers a wrap word' do
      expect(Caesar.encypher(wrapword)).to eq(wrapcypher)
    end

    it 'decyphers a word' do
      expect(Caesar.decypher(cypher)).to eq(word)
    end

    it 'encyphers a word' do
      expect(Caesar.encypher(word)).to eq(cypher)
    end

    it 'rotates z to a' do
      expect(Caesar.shift('z', 1)).to eq('a')
    end

  end

  context 'shift by 5 * 26 + 3 ' do
    let(:shift_by) { 5 * 26 + 3 }
    it 'rotates z to c' do
      expect(Caesar.shift('z', shift_by)).to eq('c')
    end

    it 'rotates a to d' do
      expect(Caesar.shift('a', shift_by)).to eq('d')
    end
  end


  context 'shift by 3' do
    let(:shift_by) { 3 }
    it 'rotates z to c' do
      expect(Caesar.shift('z', shift_by)).to eq('c')
    end

    it 'rotates a to d' do
      expect(Caesar.shift('a', shift_by)).to eq('d')
    end
  end
end
