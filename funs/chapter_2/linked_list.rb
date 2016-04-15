require_relative '../common'
class IllegalListOp < StandardError; end;

class LinkedList
  attr_reader :head
  attr_accessor :last
  def initialize head:
    @head = head
    @last = head
  end

  def << new_node
    self.last.next = new_node
    self.last = new_node
  end

  def remove_node node
    fail IllegalListOp.new("Can't remove last node") if node == last
    node.data = node.next.data
    node.next = node.next.next
  end

  def size
    [self.head].tap do |a|
      loop do
        break a if (n = a[-1].next).nil?
        a << n
      end
    end.size
  end

  def remove_kth_to_last place
    size = self.size
    nexts = [:next] * place
    remove_node(nexts.inject(head) {|me, cmd| me.send(cmd)})
  end
end

class Node
  attr_accessor :data, :next
  def initialize data: nil
    @data = data
    @next = nil
  end

  def ==(other)
    self.data == other.data
  end
end





