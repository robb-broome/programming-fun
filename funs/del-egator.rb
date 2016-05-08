require 'rspec'
require 'pry'
class Node
  extend Forwardable
  def initialize
    @payload = []
    @noload = {}
  end
  def_delegator :@payload, :push, :enq
  def_delegator :@payload, :first
  def_delegator :@noload, :merge!, :<<
  def_delegator :@noload, :[]
end

RSpec.describe Node do

  let(:node) {Node.new}
  it 'works' do
    expect{node.enq 'first'}.not_to raise_error
  end

  it 'enqueues' do
    node.enq 'first'
    expect(node.first).to eq 'first'
  end

  it 'merges' do
    node << {robb: :cool}
    expect(node[:robb]).to eq :cool
  end
end
