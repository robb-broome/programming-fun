require 'rspec'
require 'pry'
class Freq

  attr_reader :text, :frequency, :count

  def initialize text
    @text = text.downcase
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
    @text_a ||= text.split('').select{|letter| !letter.nil? && letter != ''}
  end
end

RSpec.describe Freq do
  let(:decyphered_huck) { File.read 'funs/encryption/texts/huckleberry_finn.txt' }
  it 'gives the freqency' do
    text = 'aabcd'
    freq = Freq.new(text)
    expect(freq.letter_count('a')).to eq(2)
  end

  it 'does twain' do
    pp Freq.new(decyphered_huck).count
  end

  it'results' do
    pp Freq.new(decyphered_huck).result
  end

  it'doubles' do
    pp Freq.new(decyphered_huck).doubles
  end
end

class Caesar
  A = 'a'.sum
  Z = 'z'.sum
  BASE = A - 1
  ALPHABET_SIZE = (Z - BASE)

  DEFAULT_SHIFT = 1
  ENCODING = 'US-ASCII'

  attr_accessor :text

  def initialize(text)
    @text=text.downcase
  end

  def multiple_cypher(times, shift_by= DEFAULT_SHIFT)
    times.times do |n|
      puts text
      self.text  = shift_text(shift_by)
    end
    text
  end

  def encypher(shift_by = DEFAULT_SHIFT)
    shift_text(shift_by)
  end

  def decypher(shift_by = DEFAULT_SHIFT)
    shift_text(shift_by * -1)
  end

  def shift(letter, shift_by)
    # do not handle punctuation for now
    return letter unless letter.sum.between?(A,Z)
    to_char(shifted_position(letter, shift_by) + BASE)
  end

  def shift_text(shift_by)
    text.split('').map {|letter| shift(letter, shift_by) }.join
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
    @text_a ||= text.split('').select{|letter| !letter.nil? && letter != ''}
  end

end

RSpec.describe Caesar do
  let(:encryptor) { Caesar.new(subject_text) }

  let(:no_wrap_text) { 'abcde' }
  let(:no_wrap_cypher) { 'bcdef' }

  let(:wrap_text) { 'wxyz' }
  let(:wrap_cypher) { 'xyza' }

  let(:decyphered_huck) { File.open 'funs/encryption/texts/huckleberry_finn.txt' }

  after do
    close decyphered_huck rescue nil
  end

  context 'multiple cypher' do
    let(:subject_text) { no_wrap_text }

    it 'encrypts 999 times' do
      pp encryptor.multiple_cypher(999)
    end
  end
  context 'large texts' do
    let(:subject_text) { File.read(decyphered_huck) }
    it 'encrypts them' do
      expect{encryptor.encypher}.not_to raise_error
    end

    it 'encrypts twain' do
      pp encryptor.encypher
    end

    it 'round-trips them' do
      cypher_huck = Tempfile.new('cypher_huck') << encryptor.encypher
      round_trip_huck = Tempfile.new('decypher_huck') << Caesar.new(File.read(cypher_huck)).decypher
      round_trip_huck.rewind
      while true do
        decyphered_huck.each_line do |decyphered_line|
          rt_line = round_trip_huck.readline
          expect(rt_line).to eq(decyphered_line.downcase)
        end
        break
      end
    end
  end

  context 'letter shifting' do
    let(:subject_text) { no_wrap_text }
    context 'by default value' do
      it 'shifts' do
        expect(encryptor.shift('a', 1)).to eq('b')
      end

      it 'to left' do
        expect(encryptor.shift('b', -1)).to eq('a')
      end

      it 'to left and rotate' do
        expect(encryptor.shift('a', -1)).to eq('z')
      end

      it 'rotates z to a' do
        expect(encryptor.shift('z', 1)).to eq('a')
      end

      context 'shift by 3' do
        let(:shift_by) { 3 }
        it 'rotates z to c' do
          expect(encryptor.shift('z', shift_by)).to eq('c')
        end

        it 'rotates a to d' do
          expect(encryptor.shift('a', shift_by)).to eq('d')
        end
      end

      context 'shift by 5 * 26 + 3 ' do
        let(:shift_by) { 5 * 26 + 3 }
        it 'rotates z to c' do
          expect(encryptor.shift('z', shift_by)).to eq('c')
        end

        it 'rotates a to d' do
          expect(encryptor.shift('a', shift_by)).to eq('d')
        end
      end
    end
  end


  context 'decyphering' do
    let(:subject_text) { no_wrap_cypher }

    it 'decyphers a text' do
      expect(encryptor.decypher).to eq(no_wrap_text)
    end
  end


  context 'encyphering' do
    context 'texts that wrap' do
      let(:subject_text) { wrap_text }
      it 'encyphers a wrap text' do
        expect(encryptor.encypher).to eq(wrap_cypher)
      end
    end

    context 'texts that do not wrap' do
      let(:subject_text) { no_wrap_text }

      it 'encyphers a text' do
        expect(encryptor.encypher).to eq(no_wrap_cypher)
      end
    end
  end
end
