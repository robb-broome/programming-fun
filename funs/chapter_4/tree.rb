require 'rspec'
class MinHeap
  attr_accessor :root
  def initialize els
    @root = Node.new(els.shift)
    els.each do |el|
      root << Node.new(el)
      fix(root)
    end
  end

  def fix(node)
    node_val = node.val
    if node_val > node.left.value
      node.value = node.left.value
      node.left.value = node_val
    end
  end

end

class Node
  attr_accessor :value, :left, :right
  def initialize val
    @value = val
    @right = nil
    @left = nil
  end

  def << child
    # get the bottom right node
    # add child to that node's right
    # if child < that node, swap them
    # if other child < new top, swap them

  end
end

RSpec.describe BTree do
  it 'makes a tree' do
    expect MinHeap.new([1,4,8,12,16]).to be_a(MinHeap)
  end
end
