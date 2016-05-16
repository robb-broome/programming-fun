require 'rspec'

# connecting dots
#   draw a line from one dot to another
#   to do that, dots have to have a name
#   in a two-order board, there are 4 boxes 2**n
#   in a 5 order board, there are 25 boxes.
#   a box is complete if it's edges are all connected
#   a complete box has an owner
#   a box has a position on the board
#   a board has a coordinate system
#   arbitrarily say that the lower left dot is origin (0,0)
#   box locations are 1's based
#     the lower left box is located at 0,0
#     the lower left box #origin is 0,0
#   the lower left box's corners are (clockwise from origin)
#   (Note: these also happen to be the coordinates of the dots)
#      0,0
#      0,1
#      1,1
#      1,0
#
#   the lower right box is located at 0,1
#     the lower right box #origin is 0,1
#     the lower right box is bound by dots (clockwise)
#       0,1 (it's origin)
#       1,1
#       2,1
#       2,0
#
class Board
  attr_reader :boxes
  def initialize boxes: 0
    @boxes = boxes
  end


end

class Box
  attr_accessor :owner
  attr_reader :x, :y

  def initialize  x, y
    @x = x
    @y = y
  end

end

RSpec.describe Board do
  it { is_expected.to be_a Board}
  describe Board.new(boxes: 2) do
    it 'has two boxes' do
      expect(described_class.boxes).to eq(2)
    end
  end
end
