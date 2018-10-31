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
    # TODO: handle any node.
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
    remove_node(nexts.inject(head) {|node, cmd| node.send(cmd)})
  end

  def remove_last
  end

  def rm_dupes
    node = head
    known_elements = [node.data]
    loop do
      break unless node = node.next
      if known_elements.include? node.data
        self.remove_node(node)
      else
        known_elements << node.data
      end
    end
  end

  def rm_dupes_no_buffer
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

require 'spec_helper'

def create_list node_count: 1
  ll = LinkedList.new(head: Node.new(data: 0))
  (1..node_count - 1).each do |node_num|
    new_node = Node.new( data: node_num)
    ll << new_node
  end
  ll
end

RSpec.describe LinkedList do

  let(:list) { create_list node_count: 4 }
  let(:node1) { list.head.next }

  it 'has a node' do
    expect(node1).to be_instance_of(Node)
  end

  it 'makes a list' do
    data = 0
    list = LinkedList.new(head: Node.new(data: data))
    expect(list).to be_instance_of(LinkedList)
    expect(list.head).to be_instance_of(Node)
    expect(list.head.data).to eq data
  end

  it 'takes a next' do
    old_last = list.last
    new_node = Node.new data: 'new-data'
    expect {list << new_node}.to change{list.last}.from(old_last).to(new_node)
  end

  it 'removes a node' do
    node_to_remove = list.head.next # node 1
    expect(list.head.next.data).to eq(1)
    list.remove_node node_to_remove
    expect(list.head.next.data).to eq(2)
  end

  it 'raises if removing the last node' do
    node_to_remove = list.last
    expect{list.remove_node(node_to_remove)}.to raise_error IllegalListOp
  end

  it 'says size' do
    expect(list.size).to eq 4
  end

  it 'gets size of a single item list' do
    list = LinkedList.new(head: Node.new(data: 0))
    expect(list.size).to eq(1)
  end

  specify 'removing a node changes the size of the list' do
    node_to_remove = list.head.next # node 1
    expect{list.remove_node node_to_remove}.to change{ list.size }.by(-1)
  end

  specify 'removing a node changes the size of the list' do
    expect{list << Node.new(data: 6)}.to change{ list.size }.by(1)
  end

  describe 'kth to last' do

    it 'returns 2nd to last node' do
      second_to_last = list.head.next.next
      #                      0    1    2
      last = list.last
      list.remove_kth_to_last(2)
      expect(list.last.data).to eq(3)
      expect(list.head.next.next).to eq(last)
    end
  end

  describe 'remove dups without buffer' do
    let(:list) { create_list node_count: 4 }
    let(:to_dup) {list.head.next.data}
    before do
      list << Node.new(data: to_dup)
    end

    it 'removes dup entries' do
      expect{ list.rm_dupes_no_buffer }.to change{ list.size }.by(-1)
    end
  end

  describe 'remove dups' do
    let(:list) { create_list node_count: 4 }
    let(:to_dup) {list.head.next.data}
    before do
      list << Node.new(data: to_dup)
    end

    it 'removes dup entries' do
      expect{ list.rm_dupes }.to change{ list.size }.by(-1)
    end
  end
end
