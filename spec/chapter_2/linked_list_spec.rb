require 'spec_helper'

def create_list node_count: 1
  ll = LinkedList.new Node.new data: 'node 0 head'
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
    list = LinkedList.new Node.new data: data
    expect(list).to be_instance_of(LinkedList)
    expect(list.head).to be_instance_of(Node)
    expect(list.head.data).to eq data
  end

  it 'takes a next' do
    old_last = list.last
    new_node = Node.new data: 'new-data'

    list << new_node

    expect {list << new_node}.to change{list.last}.from(old_last).to(new_node)

  end



end
