require 'rspec'

def move_zeros(nums)
  shift_count = 0
  length = nums.count
  index = 0
  while index < length
    if nums[index + shift_count] == 0
      shift_count += 1
      nums << 0
    end
    nums[index] = nums[index + shift_count]
    index += 1
  end
  nums[0..length - 1]
end

RSpec.describe 'move_zeros' do
  it 'moves them to the end' do
    input = [0,1,0,3,12]
    output = [1,3,12,0,0]
    expect(move_zeros(input)).to eq(output)
  end
end
