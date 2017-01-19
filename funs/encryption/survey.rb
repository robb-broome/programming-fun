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

  def clean_text
    @clean_text ||= text_a.select{|letter| letter.between?(ALPHABET[0], ALPHABET[-1])}.join
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
  MIN_REPEAT = 30 # good for long texts

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

  def repeats(size, min_repeat=MIN_REPEAT)
    repeats = Hash.new {|h, k| h[k] = 0 }

    clean_text.each_char.with_index do |letter, index|
      segment = clean_text[index, size]
      repeats[segment] += 1
    end
    repeats.delete_if{|k, v| v < min_repeat}
    val = repeats.sort{|a, b| a[1] <=> b[1]}
    Hash[val]
  end

  def repeat_offsets(size, min_repeat = MIN_REPEAT)
    repeat_freq = Hash.new {|h, k| h[k] = [] }
    repeats = repeats(size, min_repeat).keys.reverse.last(5)
    clean_text.each_char.with_index do |letter, index|
      segment = clean_text[index, size]
      next unless repeats.include?(segment)
      repeat_freq[segment] << index
    end
    repeat_freq
  end

  def repeat_interval(size, min_repeat = MIN_REPEAT)
    # distance between repeats. LCD of these may be key length
    intervals = Hash.new {|h, k| h[k] = [] }

    repeat_offsets(size, min_repeat).each do |repeated_chars, offsets|
      last_offset = offsets.shift
      offsets.each do |offset|
        intervals[repeated_chars] << offset - last_offset
        last_offset = offset
      end
    end
    intervals
  end

  def histo(value_sets)
    histo = Hash.new(0)
    value_sets.flatten.each do |value|
      histo[value] += 1
    end
    histo
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

  def double_letters
    double_letters = Hash.new {|h, k| h[k] = 0 }
    last = nil
    text_a.each do |letter|
      double_letters[ letter * 2 ] += 1 if letter == last
      last = letter
    end
    double_letters.sort{|a, b| a[1] <=> b[1]}.reverse
  end

  def digest
    text_a.each do |letter|
      next if letter.nil? || letter == ''
      @count[letter] += 1
    end
  end

end

RSpec.describe Freq do
  let(:deciphered_huck) { File.read 'funs/encryption/texts/huckleberry_finn.txt' }
  let(:text) { 'aabcd' }
  let(:freq) { Freq.new(text) }

  it 'gives the freqency of a letter in the text' do
    expect(freq.letter_count('a')).to eq(2)
  end

  context 'a long text' do
    let(:text) { deciphered_huck }
    it 'lists counts' do
      pp freq.count
    end

    it 'lists count and frequency ' do
      pp freq.result
    end

    it'lists double_letters' do
      pp freq.double_letters
    end

    it 'lists repeat frequency' do
      pp freq.repeats(6)
    end

    it 'lists repeat offsets' do
      pp freq.repeat_offsets(15)
    end
  end

  describe 'repeat intervals' do

    context 'short text' do
      let(:text) { 'qxxxabcdexxxfghijklmnoxxxp' }
      it 'detects  interval between repeats' do
        expect(freq.repeat_interval(3,2)).to eq({'xxx' => [8,13]})
      end
    end

    context 'long text' do
      let(:ten_place_key) { 'abcdefghijk' }
      let(:text) { Vigenere.new(deciphered_huck, ten_place_key).encipher }
      let(:min_repeats) { 15 }
      let(:word_length) { 8 }
      # let(:text) { 'a sentence with repeated sentence repeated yy  repeated xx sentence' }
      it 'detects  interval between repeats' do
        pp freq.repeats(word_length,min_repeats)
        intervals = freq.repeat_interval(word_length, min_repeats)
        pp intervals
        pp histo = freq.histo( intervals.values )
        bigggest_occurance_value = histo.values.uniq.sort.last
        highest =  histo.select{ |key, value| value == bigggest_occurance_value}
        puts 'highest: ', highest.keys.sort

          
      end
    end
  end

  context 'repeat frequency' do
    let(:text) { 'abcdefdefcde' }
    it 'finds repeats' do
      expect(freq.repeats(3)).to eq({'cde' => 2, 'def' => 2 })
    end
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
    clean_text.each_char.map do |letter|
      shift_value = key_shifts[key_position]
      key_position = (key_position + 1) % key_length
      shift(letter, shift_value)
    end.join
  end

  def decipher
    key_position = 0
    clean_text.each_char.map do |letter|
      shift_value = key_shifts[key_position]
      key_position = (key_position + 1) % key_length
      key_row_letter_position = (position(letter) - 1) - shift_value
      ALPHABET[key_row_letter_position]
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
  let(:key) { 'pixeloshazzam' }
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
