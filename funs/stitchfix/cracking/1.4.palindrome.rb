# frozen_string_literal: true
#
class Palindrome
  attr_reader :p1, :p2
  def initialize(p1, p2 = '')
    @p1 = p1
    @p2 = p2
  end

  def palindrome_permutation?
    return false if p1.length != p2.length
    return false unless valid_palindrome?(letter_counts_p1)

    p2.each_char {|char| letter_counts_p1[char] -= 1}
    letter_counts_p1.values.all?(&:zero?)
  end

  def true_palindrome_bitmapped?
    bitVector = 0
    base = 'a'.ord
    p1.each_char do |letter|
      index = letter.ord - base
      mask = 1 << index
      puts "bitvector is #{bitVector.to_s(2)}"
      if bitVector & mask == 0
        # not yet seen, so far only odd quantities
        # of this letter are known
        bitVector = bitVector | mask
      else
        # already seen, toggle the digit off
        # This indicates an even number of this letter
        # the '~' operator gives the inverse of the number
        bitVector = bitVector & ~mask
      end
    end

    # NOTE about the next step:
    # IF the phrase contains only one letter with an odd count,
    # then the bitVector will have only only one '1' digit.
    #
    # Subtracting 1 from the bitVector  will make another binary number
    # that has no digits in common with the original
    # and performing AND between these two will == zero.
    #
    # Otherwise, the result will not be zero, indicating
    # that there are > 1 odd numbers in the phrase.
    #
    # Example, say our bitVector has one '1' digit...
    # say...
    # 000010000
    # then subtracting one makes it
    # 000001111
    # - note that these two have no digit
    # in common, so if you AND them the result will be zero.
    #
    if bitVector & (bitVector - 1) == 0
      return true
    else
      return false
    end
  end

  private

  def letter_counts_p1
    @letter_counts_p1 ||= letter_counts(p1)
  end

  def valid_palindrome?(string)
    # no more than one odd count
    odd_found = false
    letter_counts_p1.values.each do |count|
      if count % 2 != 0
        if odd_found
          return false
        else
          odd_found = true
        end
      end
    end
    true
  end

  def letter_counts(string)
    letter_counts = Hash.new {|h, k| h[k] = 0}
    string.each_char {|char| letter_counts[char] += 1}
    letter_counts
  end
end


RSpec.describe Palindrome do
  subject(:detector) { Palindrome.new(p1, p2) }


  describe 'bitmap solution'do
    context 'when it is a true palindrome' do
      let(:p1) { 'abcddcba' }
      let(:p2) { 'not needed' }
      it 'accepts the palindrome' do
        expect(detector.true_palindrome_bitmapped?).to be_truthy
      end
    end
    context 'when not' do
      let(:p1) { 'abcdxydcba' }
      let(:p2) { 'not needed' }
      it 'rejects the palindrome' do
        expect(detector.true_palindrome_bitmapped?).to be_falsey
      end
    end
  end

  describe 'when the two are permuted palindromes' do
    let(:p1) { 'abcddcba' }
    let(:p2) { 'ddccaabb' }

    it 'detects a palindrome permutation' do
      expect(detector.palindrome_permutation?).to be_truthy
    end
  end

  describe 'when the two are not permuted palindromes' do

    context 'when the strings have different length' do
      let(:p1) { 'abcddcba' }
      let(:p2) { 'abcddcbaX' }
      it 'rejects' do
        expect(detector.palindrome_permutation?).to be_falsey
      end
    end

    context 'when the strings have different case' do
      let(:p1) { 'abcddcba' }
      let(:p2) { 'abcddcbA' }
      it 'rejects' do
        expect(detector.palindrome_permutation?).to be_falsey
      end
    end

    context 'when the strings have different whitespace' do
      let(:p1) { 'abcddcba' }
      let(:p2) { 'abcddcb a' }
      it 'rejects' do
        expect(detector.palindrome_permutation?).to be_falsey
      end
    end

    context 'when the first item is not a palindrome' do
      let(:p1) { 'abcd' }
      let(:p2) { 'abcd' }
      it 'rejects' do
        expect(detector.palindrome_permutation?).to be_falsey
      end
    end

    context 'when both are empty' do
      let(:p1) { '' }
      let(:p2) { '' }
      it 'rejects' do
        # WHAT????!!!!
        expect(detector.palindrome_permutation?).to be_truthy
      end
    end
  end
end
