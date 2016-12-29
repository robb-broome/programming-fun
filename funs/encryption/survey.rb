require 'rspec'
require 'pry'

class Encryptor
  ALPHABET = ('a'..'z').to_a
  A = ALPHABET[0].sum
  Z = ALPHABET[-1].sum
  BASE = A - 1
  ALPHABET_SIZE = ALPHABET.count


  DEFAULT_SHIFT = 1
  ENCODING = 'US-ASCII'
  attr_accessor :text

  def initialize(text)
    @text=text.downcase
  end

  def shift_text(shift_by)
    text.split('').map {|letter| shift(letter, shift_by) }.join
  end

  def shift(letter, shift_by)
    # TODO: handle punctuation. Maybe delete?
    return letter unless letter.sum.between?(A,Z)
    to_char(shifted_position(letter, shift_by) + BASE)
  end

  def position(letter)
    letter.sum % BASE
  end

  def shifted_position(letter, shift_by)
    shifted_position = (position(letter) + shift_by) % ALPHABET_SIZE
    shifted_position == 0 ? ALPHABET_SIZE : shifted_position
  end

  def to_char( code )
    code.chr ENCODING
  end

  def text_a
    @text_a ||= to_a(text)
  end

  def to_a( tmp_text )
    tmp_text.split('').select{|letter| !letter.nil? && letter != ''}
  end
end

class MexicanArmy < Encryptor
  # 
end

RSpec.describe MexicanArmy do
end

class Freq < Encryptor
  # frequency analysis on text

  attr_reader :text, :frequency, :count

  def initialize text
    super
    @frequency = Hash.new {|h, k| h[k] = 0 }
    @count = Hash.new {|h, k| h[k] = 0 }
    digest
  end

  def letter_freq letter
    frequency[letter]
  end

  def letter_count letter
    count[letter]
  end

  def result
    result = {}
    total_chars = count.values.reduce(0) {|v, memo| memo += v }
    count.each do |letter, letter_count|
      frequency[letter] = (letter_count.to_f / total_chars).round(6)
      result[letter] = {count: letter_count, frequency: frequency[letter]}
    end
    result.sort {|a, b| a[1][:frequency] <=> b[1][:frequency] }.reverse
  end

  def doubles
    doubles = Hash.new {|h, k| h[k] = 0 }
    last = nil
    text_a.each do |letter|
      doubles[ letter * 2 ] += 1 if letter == last
      last = letter
    end
    doubles.sort{|a, b| a[1] <=> b[1]}.reverse
  end

  def digest
    text_a.each do |letter|
      next if letter.nil? || letter == ''
      @count[letter] += 1
    end
  end

  def text_a
    @text_a ||= to_a(text)
  end

end

RSpec.describe Freq do
  let(:deciphered_huck) { File.read 'funs/encryption/texts/huckleberry_finn.txt' }
  it 'gives the freqency' do
    text = 'aabcd'
    freq = Freq.new(text)
    expect(freq.letter_count('a')).to eq(2)
  end

  it 'does twain' do
    pp Freq.new(deciphered_huck).count
  end

  it'results' do
    pp Freq.new(deciphered_huck).result
  end

  it'doubles' do
    pp Freq.new(deciphered_huck).doubles
  end
end

class Caesar < Encryptor
  def multiple_cipher(times, shift_by= DEFAULT_SHIFT)
    times.times do |n|
      self.text  = shift_text(shift_by)
    end
    text
  end

  def encipher(shift_by = DEFAULT_SHIFT)
    shift_text(shift_by)
  end

  def decipher(shift_by = DEFAULT_SHIFT)
    shift_text(shift_by * -1)
  end

end

class Vigenere < Caesar

  attr_accessor :key

  def initialize text, key
    super(text)
    @key = key
  end

  def encipher
    key_position = 0
    text_a.map do |letter|
      if letter.sum.between?(A,Z)
        shift_value = key_shifts[key_position]
        key_position = (key_position + 1) % key_length
        shift(letter, shift_value)
      else
        letter
      end
    end.join
  end

  def decipher
    key_position = 0
    text_a.map do |letter|
      if letter.sum.between?(A,Z)
        shift_value = key_shifts[key_position]
        key_position = (key_position + 1) % key_length
        key_row_letter_position = (position(letter) - 1) - shift_value
        ALPHABET[key_row_letter_position]
      else
        letter
      end
    end.join
  end

  private

  def key_length
    key.length
  end

  def key_shifts
    @key_shifts ||= to_a(key).map {|letter| position(letter) - 1 }
  end
end

RSpec.describe Vigenere do
  let(:text) { 'eeeeee' }
  let(:encrypted_text) { 'tmbips' }
  let(:key) { 'pixelo' }
  let(:encipherer)  { Vigenere.new(text, key) }
  let(:deciphered_huck) { File.read 'funs/encryption/texts/huckleberry_finn.txt' }

  it 'initializes' do
    expect(encipherer).to be_a(Vigenere)
  end

  it 'has a keyword' do
    expect(encipherer.key).to eq(key)
  end

  it 'encrypts with a keyword' do
    expect(encipherer.encipher).to eq encrypted_text
  end

  it 'decrypts with a keyword' do
    encipherer = Vigenere.new(encrypted_text, key)
    expect(encipherer.decipher).to eq text
  end

  context 'long text' do
    let(:text) { deciphered_huck }

    it 'encrypts huck' do
      pp encipherer.encipher
    end

    it 'round-trips huck' do
      pp Vigenere.new(encipherer.encipher, key).decipher
    end

  end
end

RSpec.describe Caesar do
  let(:encipherer) { Caesar.new(subject_text) }

  let(:no_wrap_text) { 'abcde' }
  let(:no_wrap_cipher) { 'bcdef' }

  let(:wrap_text) { 'wxyz' }
  let(:wrap_cipher) { 'xyza' }

  let(:deciphered_huck) { File.open 'funs/encryption/texts/huckleberry_finn.txt' }

  after do
    close deciphered_huck rescue nil
  end

  context 'multiple cipher' do
    let(:subject_text) { no_wrap_text }

    it 'encrypts 9 times' do
      pp encipherer.multiple_cipher(9)
    end
  end
  context 'large texts' do
    let(:subject_text) { File.read(deciphered_huck) }
    it 'encrypts them' do
      expect{encipherer.encipher}.not_to raise_error
    end

    it 'encrypts twain' do
      pp encipherer.encipher
    end

    it 'round-trips them' do
      cipher_huck = Tempfile.new('cipher_huck') << encipherer.encipher
      round_trip_huck = Tempfile.new('decipher_huck') << Caesar.new(File.read(cipher_huck)).decipher
      round_trip_huck.rewind
      while true do
        deciphered_huck.each_line do |deciphered_line|
          rt_line = round_trip_huck.readline
          expect(rt_line).to eq(deciphered_line.downcase)
        end
        break
      end
    end
  end

  context 'letter shifting' do
    let(:subject_text) { no_wrap_text }
    context 'by default value' do
      it 'shifts' do
        expect(encipherer.shift('a', 1)).to eq('b')
      end

      it 'to left' do
        expect(encipherer.shift('b', -1)).to eq('a')
      end

      it 'to left and rotate' do
        expect(encipherer.shift('a', -1)).to eq('z')
      end

      it 'rotates z to a' do
        expect(encipherer.shift('z', 1)).to eq('a')
      end

      context 'shift by 3' do
        let(:shift_by) { 3 }
        it 'rotates z to c' do
          expect(encipherer.shift('z', shift_by)).to eq('c')
        end

        it 'rotates a to d' do
          expect(encipherer.shift('a', shift_by)).to eq('d')
        end
      end

      context 'shift by 5 * 26 + 3 ' do
        let(:shift_by) { 5 * 26 + 3 }
        it 'rotates z to c' do
          expect(encipherer.shift('z', shift_by)).to eq('c')
        end

        it 'rotates a to d' do
          expect(encipherer.shift('a', shift_by)).to eq('d')
        end
      end
    end
  end


  context 'deciphering' do
    let(:subject_text) { no_wrap_cipher }

    it 'deciphers a text' do
      expect(encipherer.decipher).to eq(no_wrap_text)
    end
  end

  context 'enciphering' do
    context 'texts that wrap' do
      let(:subject_text) { wrap_text }
      it 'enciphers a wrap text' do
        expect(encipherer.encipher).to eq(wrap_cipher)
      end
    end

    context 'texts that do not wrap' do
      let(:subject_text) { no_wrap_text }

      it 'enciphers a text' do
        expect(encipherer.encipher).to eq(no_wrap_cipher)
      end
    end
  end
end
