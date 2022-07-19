require 'pry'
def one_away(s1, s2)
  # NB: this is fancy as hell, but it doesn't work at all. 
  # insert, delete, or change one character
  puts s1, s2

  # first , are these just one character different?
  return false if ( s1.length - s2.length ).abs  > 1

  # are all the characters the same?
  bitVector = 0
  base = 'a'.ord
  format = "%20s"
  s1.each_char do |letter|
    mask = 1 << letter.ord - base
    puts "for #{letter}, mask is \t #{format % mask.to_s(2)}"
    bitVector = bitVector | mask
    puts "BitVector is \t #{format % bitVector.to_s(2)}"
    puts
  end

  puts 'decrementing'
  puts

  s2.each_char do |letter|
    # each one here should be in bitvector, except 1 max
    # so remove each from the bitVector. What remains
    # should == 1 or 0
    mask = 1 << letter.ord - base
    puts "for #{letter}, mask is \t #{format % mask.to_s(2)}"
    bitVector = bitVector & ~mask
    puts "BitVector is \t #{format % bitVector.to_s(2)}"
    puts
  end
  puts "Final is \t #{format % bitVector.to_s(2)}"

  return true if bitVector & (bitVector - 1) == 0
  false
end

RSpec.describe 'one_away' do
  subject(:test) { one_away(s1, s2) }

  context 'with really long strings' do
    let(:s1) { 'now is the time for all good men to come to the aid of their country' }
    let(:s2) { 'xxw is the time for all good men to come to the aid of their country' }
    it 'accepts' do
      expect(test).to be_truthy
    end
  end

  context 'with repeated characters and too many diffs' do
    let(:s1) { 'pppppppppppp' }
    let(:s2) { 'ppppppppppaa' }
    it 'rejects' do
      expect(test).to be_falsey
    end
  end

  context 'with repeated characters' do
    let(:s1) { 'pppppppppppp' }
    let(:s2) { 'pppppppppppa' }
    it 'accepts' do
      expect(test).to be_truthy
    end
  end

  context 'when the strings are > 1 character different in length' do
    let(:s1) { 'palexx' }
    let(:s2) { 'ple' }
    it 'rejects' do
      expect(test).to be_falsey
    end
  end

  context 'when the strings are  1 character different in length, otherwise identical' do
    let(:s1) { 'pale' }
    let(:s2) { 'ple' }
    it 'accepts' do
      expect(test).to be_truthy
    end
  end

  context 'when strings differ by the value of one character and out of order' do
    let(:s1) { 'apel' }
    let(:s2) { 'pole' }
    it 'accepts' do
      expect(test).to be_truthy
    end
  end

  context 'when strings differ by the value of one character' do
    let(:s1) { 'pale' }
    let(:s2) { 'pole' }
    it 'accepts' do
      expect(test).to be_truthy
    end
  end

  context 'when strings are identical and out of order' do
    let(:s1) { 'ealp' }
    let(:s2) { 'pale' }
    it 'accepts' do
      expect(test).to be_truthy
    end
  end

  context 'when strings are identical' do
    let(:s1) { 'pale' }
    let(:s2) { 'pale' }
    it 'accepts' do
      expect(test).to be_truthy
    end
  end

  context 'when strings differ by the value of two characters' do
    let(:s1) { 'pale' }
    let(:s2) { 'dole' }
    it 'rejects' do
      expect(test).to be_falsey
    end
  end
end
