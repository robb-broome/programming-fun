require 'rspec'
require 'pry'
class Problem
  def self.single_number(numbers)
    # add each to a hash, but check to see if it's there first.
    # if it was alr
    counter = Hash.new {|h, k| h[k] = 0 }
    numbers.each do |number|
      counter[number] += 1
    end
    # find the entry that == 1 and return the key
    #
    counter.each do |num, count|
      return num if count == 1
    end
    false
  end

  def self.sorted(numbers)
    numbers.sort!
    pointer = 0
    count = numbers.count

    while pointer < count
      base = numbers[pointer]
      while true
        brea if pointer >= count
        return base if numbers[pointer += 1] != base
        break if numbers[pointer + 1 ]  != base
      end
    end
  end

  def self.crawler(numbers)
    seen_before = []
    test_set = Set.new
    numbers.each do |number|
      seen_before << number if !test_set.add?(number)
    end
    (numbers - seen_before).first
  end

  def self.single_number_set(numbers)
    potential_singles = Set[*numbers]
    test_set = Set.new
    numbers.each do |number|
      if !test_set.add?(number)
        potential_singles.delete(number)
      end
      if potential_singles.size == 1
        return potential_singles.first
      end
    end
  end
end


RSpec.describe Problem do
  context 'with a set of numbers' do
    let(:numbers) { [4,1,2,1,2,2,4,6] }
    let(:the_right_answer) { 6 }
    it 'with hash, returns the single number in the set' do
      expect(Problem.single_number(numbers)).to eq(the_right_answer)
    end
    it 'with set, returns the single number in the set' do
      expect(Problem.single_number_set(numbers)).to eq(the_right_answer)
    end
    it 'with crawler, returns the right thing' do
      expect(Problem.crawler(numbers)).to eq(the_right_answer)
    end
  end
end
