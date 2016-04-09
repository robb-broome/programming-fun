require_relative '../common'

class LinkedList
  attr_reader :head
  attr_accessor :last
  def initialize head
    @head = head
    @last = head
  end

  def << new_node
    last_node = last
    last_node.next = new_node

    binding.pry
    last = new_node
  end

  def remove_node node
    return nil if node == last
    next_node = node.next
    after_next = next_node.next
    node.data = next_node.data
    node.next = after_next
  end


end

class Node
  attr_accessor :data, :next
  def initialize data: nil
    @data = data
    @next = nil
  end
end





