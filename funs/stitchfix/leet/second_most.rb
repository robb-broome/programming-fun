require 'pry'
class SecondMost
  TOTAL_CHARS = 256
  def self.find(str)
    counter = Array.new(TOTAL_CHARS) {0}

    # load with letter frequency
    str.each_char { |char| counter[char.ord] += 1 }

    first_place_index = second_place_index = 0

    (0..TOTAL_CHARS - 1).each do |position|
      if counter[position] > counter[first_place_index]
        second_place_index = first_place_index
        first_place_index = position
      elsif counter[position] > counter[second_place_index] &&
        counter[position] != counter[first_place_index]
        second_place_index = position
      end
    end


    puts "First Place, with #{counter[first_place_index]}, is: #{first_place_index.chr}"
    puts "Second Place, with #{counter[second_place_index]}, is: #{second_place_index.chr}"
    second_place_index.chr
  end
end

RSpec.describe SecondMost do
  it 'finds the second most freqent character in a string' do
    string = '9' * 900
    string += 'b' * 890
    string += 'c' * 880
    expect(SecondMost.find(string)).to eq('b')
  end
end
