require 'pry'
class REMatch
  def match?(str, expr)
    chunks = chunks(expr, '.*')
    left = right = 0
    match = false
    chunks.each do |chunk|
      right = left + chunk.length - 1
      substring = str[left..right]
      if chunk == substring
        # this part matches
        puts "match on chunk: #{chunk}"
        match = true
      elsif chunk == '.*'
        # this matches this piece and everything following
        puts "Global match"
        match = true
        break
      else
        # no match here, no need to go further
        puts "broken match #{chunk} => #{substring}"
        match = false
        break
      end
      # move the pointer along
      left = right
      puts "Left: #{left}, right #{right}"
      break if left >= str.length - 1
    end
    match
  end

  def chunks(pattern, expressions)
    # parse the patterns into
    # literal and symbol parts
    # start with the longest expression
    expressions.sort! {|a, b| b.length <=> a.length }

    string_length = pattern.length
    chunks = []
    follower = pointer = 0
    current_pattern = nil
    # return [expr] if expr == pattern
    while pointer <= string_length
      token_locations = {}

      # find the earliest inclusion of any of the expressions
      # in the string.
      # use the expression that was found first
      first_expression = first_instance(pattern[pointer, -1], expressions]

      expression_length = expression.length
      pointer = pattern.index(expression, pointer) || string_length
      if pointer == string_length
        chunks << pattern[follower, pointer]
        break
      elsif pointer < string_length
        # take the part before, and the expression
        chunks << pattern[follower, pointer - follower]
        # take the expression
        chunks << pattern[pointer, expression_length]

        # we are now at pointer + expression length
        # starting point for next
        pointer += expression_length
        follower = pointer
      end
    end
    chunks.compact
  end

  def first_instance(pattern, expressions)
    # a dict of all
      expressions.reduce({}) do |memo, expression|
        found_at = pattern.index(expression, pointer)
        next if found_at.nil?
        memo[found_at] = expression
        memo
      end

  end
end

RSpec.describe REMatch do
  subject(:matcher) { described_class.new }

  describe 'chunkifier' do
    context 'with > 1 matcher' do
      let(:expression) { ['.','.*'] }
      it 'chunks' do
        chunks = matcher.chunks('some_string', expression)
      end
    end

    context 'with one matcher expression' do
      let(:expression) { ['.*'] }
      it 'base case' do
        chunks = matcher.chunks(expression[0], expression)
        puts chunks.inspect
        expect(chunks.count).to eq 1
      end

      it 'makes chunks' do
        chunks = matcher.chunks('thisis.*got.*chunks','.*')
        puts chunks.inspect
        expect(chunks.count).to eq 5
      end

      it 'finds one chunk' do
        chunks = matcher.chunks('thisisgotnochunks','.*')
        puts chunks
        expect(chunks.count).to eq(1)
      end

      it 'uses any expression' do
        chunks = matcher.chunks('thisisgotsomechunks','o')
        puts chunks
        expect(chunks.count).to eq(1)
      end
    end
  end

  describe 'matching' do
    it 'matches the wildcard' do
      expect(matcher.match?('abcd', '.*')).to be_truthy
    end

    it 'does not match if there is something else' do
      expect(matcher.match?('abcd', 'z.*')).not_to be_truthy
    end

    it 'does match if the segments match' do
      expect(matcher.match?('abcd', 'abcd.*')).to be_truthy
    end
  end
end
