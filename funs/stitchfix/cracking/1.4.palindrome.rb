# frozen_string_literal: true
#
class Palindrome
  attr_reader :p1, :p2, :letter_counts_p1
  def initialize(p1, p2)
    @p1 = p1
    @p2 = p2
    @letter_counts_p1 = letter_counts(p1)
  end

  def palindrome_permutation?
    return false if p1.length != p2.length
    return false unless valid_palindrome?(letter_counts_p1)

    p2.each_char {|char| letter_counts_p1[char] -= 1}
    letter_counts_p1.values.all?(&:zero?)
  end

  private

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
