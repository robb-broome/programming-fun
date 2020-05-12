require 'benchmark'
require 'rspec'
require 'pry'
class AbsDiff
  attr_reader :seed, :normalized_array
  def initialize(string_of_integers)
    @seed = string_of_integers
  end
  def normalized_array
    #expensive
    @normalized_array ||= seed.map(&:to_i).map(&:abs).sort
  end

  def count
    normalized_array.count
  end

  def minimum_diff_with_sets
    return 0 if has_dups?
    return 1 if has_consecutive?
  end

  def has_consecutive?
    normalized_array.uniq.count != count
  end

  def has_dups?
    s = Set.new
    seed.find {|element| !s.add?(element) }
  end

  def minimum_difference_brute_force
    min_diff = Float::INFINITY
    (count - 1).times do
      start = normalized_array.shift
      comp = normalized_array.first

      diff = comp - start
      min_diff = diff if diff < min_diff
      raise 'its nine' if min_diff == 9
    end
    min_diff
  end


end
RSpec.describe AbsDiff do
  class BigArray
    @@cache = {}
    class << self
      def unique(n)
        @@cache[n] ||
          @@cache[n] = begin
                         set = Set.new
                         until set.size >= n
                           puts set.size
                           set.merge( Array.new(n) { rand(1..n*100) } )
                         end
                         set.to_a[0..n-1]
                       end
      end

      def dup(n)
        start = unique(n)
        start + [start.first]
      end

      def consecutive
      end
    end
  end

  let(:big_unique_array) { BigArray.unique(n) }

  let(:big_dup_array) { BigArray.dup(n) }

  let(:big_consecutive_array) { BigArray.consecutive(n) }


  let(:simple_array) { %w(-59 -36 -13 1 -53 -92 -2 -96 -54 75).map(&:to_i) }
  let(:simple_array_with_dup) { %w(-59 -36 -13 1 -53 -59 -92 -2 -96 -54 75).map(&:to_i) }
  subject(:differ) { AbsDiff.new(simple_array) }

  describe 'minimum_diff_with_sets' do
    let(:n) { 1_000 }
    describe 'using sets' do
      context 'big arrays' do
        specify 'returns 1 if there are consecutive entries' do
          time = Benchmark.realtime do
            expect(AbsDiff.new(big_unique_array).minimum_diff_with_sets).to eq(1)
          end
          puts time
        end

        specify 'returns zero if there are dupliates for big arrays' do
          time = Benchmark.realtime do
            expect(AbsDiff.new(big_dup_array).minimum_diff_with_sets).to eq(0)
          end
          puts time
        end
      end

      context 'small arrays' do
        it 'returns zero if there are dupliates' do
          time = Benchmark.realtime do
            expect(AbsDiff.new(simple_array_with_dup).minimum_diff_with_sets).to eq(0)
          end
          puts time
        end
      end
    end
  end

  describe 'brute_force' do
    it 'finds the smallest diff' do
      time = Benchmark.realtime do
      expect(differ.minimum_difference_brute_force).to eq(1)
      end
      puts time
    end
  end
end
