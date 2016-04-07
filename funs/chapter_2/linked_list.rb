require_relative '../common'

class LinkedList
  attr_accessor :head
  def initialize head
    @head = head
  end
end

class Node
  attr_accessor :data, :next
  def initialize data: nil, next_node: nil
    @data = data
    @next = next_node
  end
end

