require 'rspec'
require 'pry'
class Q
  attr_accessor :els
  def initialize els
    @els = els
  end
end
class BFS
  class << self
    def search root, val=nil
      if root.right
        return root.right if root.right && root.right.value == val
        q.push root.rig
      end
      if root.left
        return root.left if root.left && root.left.value == val
        q.push root.left
      end

     BFS.search(root.right)
     BFS.search(root.left)

    end
  end
end

RSpec.describe BFS do
  let(:root) { MinHeap.build([3, 1, 2, 5, 6, 7, 9]).fix }
  it 'searches' do
    expect{BFS.search(root)}.not_to raise_error(StandardError)
  end

  it 'finds' do
    expect(BFS.search(root, 9)).to eq Node.new(9)
  end
end

class MinHeap
  attr_accessor :root

  class << self
    def build els, prev: []
      return if els == []
      if prev == []
        @root = Node.new(els.shift)
        prev = [@root]
      end
      next_level = [].tap do |next_level|
        prev.each do |prev_node|
          next_level << prev_node.left = Node.new(els.shift)
          next_level << prev_node.right = Node.new(els.shift)
        end
      end
      MinHeap.build els, prev: next_level
      @root
    end
  end
end

class Node
  attr_accessor :value, :left, :right
  def initialize val, right: nil, left: nil
    @value = val
    @right = right
    @left = left
  end

  def correct?
    if right
      right.correct?
      return false if self.value > right.value
    end
    if left
      left.correct?
      return false if self.value > left.value
    end
    true
  end

  def to_s
    "Value: #{value}, Left: #{left.to_s}, Right: #{right.to_s}"
  end

  def fix
    node_val = value
    left.fix if left
    right.fix if right
    if left && node_val > left.value
      self.value = left.value
      left.value = node_val
    end
    if right && value > right.value
      node_val = value
      self.value = right.value
      right.value = node_val
    end
  end
end

RSpec.describe MinHeap do
  it 'makes a tree' do
    expect(MinHeap.build([1,4,8,12,16])).to be_a(Node)
  end

  describe 'fixes a node' do
    it 'when 3, 2, 1' do
      top = Node.new(3, left: Node.new(2), right: Node.new(1) )
      top.fix
      expect(top.value).to be < top.left.value
      expect(top.value).to be < top.right.value
    end
    it 'when 2, 1, 3' do
      top = Node.new(2, left: Node.new(1), right: Node.new(3) )
      top.fix
      expect(top.value).to be < top.left.value
      expect(top.value).to be < top.right.value
    end
    it 'when 1, 3, 2' do
      top = Node.new(1, left: Node.new(3), right: Node.new(2) )
      top.fix
      expect(top.value).to be < top.left.value
      expect(top.value).to be < top.right.value
    end

    it 'when [3, 1, 4, 5, 2, 7, 9]' do
      top = MinHeap.build [3, 1, 2, 5, 6, 7, 9]
      top.fix
      expect(top).to be_correct
    end
  end
end
