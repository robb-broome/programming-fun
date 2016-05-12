# https://coderpad.io/TCCXARX4
require 'pry'
require 'rspec'

class Emitter
  attr_accessor :stream
  def initialize stream
    @stream = stream.split //
  end
  def peek; stream[0]; end
  def emit!; stream.shift; end
end

RSpec.describe Emitter do
  let(:str) {'abcd'}
  let(:emitter) {Emitter.new str}

  describe '#peek' do
    it 'gets the first available character' do
      expect(emitter.peek).to eq(str[0])
    end

    it 'does not consume the stream' do
      expect(emitter.peek).to eq(str[0])
      expect(emitter.peek).to eq(str[0])
    end
  end

  describe '#emit!' do

    context 'at end of stream' do
      before { str.length.times { emitter.emit! } }
      it 'does not fail if no stream is left' do
        expect{ emitter.emit! }.not_to raise_error
      end

      it 'returns nil' do
        expect(emitter.emit!).to be_nil
      end
    end

    it 'gets a char' do
      expect(emitter.emit!).to eq(str[0])
    end

    it 'consumes the stream' do
      emitter.emit!
      expect(emitter.emit!).to eq(str[1])
    end
  end

end

class Bencoding

  def self.decode emitter
    new(emitter).decode
  end

  attr_accessor :emitter
  def initialize emitter
    @emitter = emitter
  end

  def decode
    case emitter.peek
    when /\d/
      decode_string
    when 'i'
      element('') { emitter.emit! }.to_i
    when 'l'
      element([]) { Bencoding.decode(emitter) }
    when 'd'
      Hash[ element([]) { [Bencoding.decode(emitter), Bencoding.decode(emitter)] } ]
    end
  end

  def element kind, breaker: 'e', lstrip: true, &block
    emitter.emit! if lstrip
    kind.tap do |result|
      loop do
        break if emitter.peek == breaker
        result << yield
      end
      emitter.emit!
    end
  end

  def decode_string
    ''.tap do |result|
      string_count.times {result << emitter.emit!}
    end
  end

  def string_count
    element('', breaker: ':', lstrip: false) { emitter.emit! }.to_i
  end
end

RSpec.describe Bencoding do
  subject { Bencoding.decode(Emitter.new raw) }

  describe 'v mixed' do
    let(:raw) { "d5:usersl3:bobd4:mike4:isokee6:colorsl3:red4:blueee" }
    it { is_expected.to eq({"users" => ["bob", {"mike" => "isok"}], "colors" => ["red", "blue"]}) }
  end

  describe 'mixed' do
    let(:raw) { "d5:usersl3:bob4:mikee6:colorsl3:red4:blueee" }
    it { is_expected.to eq({"users" => ["bob", "mike"], "colors" => ["red", "blue"]}) }
  end

  describe 'list of string' do
    let(:raw) { "l5:green3:red4:bluee" }
    it { is_expected.to eq(["green", "red", "blue"]) }
  end

  describe 'dict' do
    let(:raw) { "d4:user3:bob3:agei47ee" }
    it { is_expected.to eq({'user' => 'bob', 'age' => 47} ) }
  end

  describe 'for integer input' do
    let(:raw) { "i15e" }
    it { is_expected.to eq(15) }
  end

  describe 'string with integers' do
    let(:raw) { "8:robots54" }
    it { is_expected.to eq('robots54') }
  end

  describe 'pure string' do
    let(:raw) { "3:dog" }
    it { is_expected.to eq('dog') }
  end
end
