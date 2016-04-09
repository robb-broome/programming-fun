require 'spec_helper'

def create_list node_count: 1
  ll = LinkedList.new(head: Node.new(data: 'node 0 head'))
  node_count.times do |node_num|
    new_node = Node.new( data: "node #{node_num + 1}")
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
    data = 'node 0 head'
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
    expect(list.head.next.data).to eq('node 1')
    list.remove_node node_to_remove
    expect(list.head.next.data).to eq('node 2')
  end

  it 'raises if removing the last node' do
    node_to_remove = list.last
    expect{list.remove_node(node_to_remove)}.to raise_error IllegalListOp
  end
end
