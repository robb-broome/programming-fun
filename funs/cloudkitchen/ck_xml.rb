require 'pry'
=begin
<a>
  <b>
    <c>foo</c>
    <c></c>
  </b>
  <d>blah</d>
</a>



interface Tokenizer {
  Token nextToken();
}

interface Token {
  String value();
  TokenType type();
}

enum TokenType {
  BEGIN,
  END,
  TEXT,
}

[
nextToken() -> {type=BEGIN,value=a},
nextToken() -> {type=BEGIN,value=b},
nextToken() -> {type=BEGIN,value=c},
nextToken() -> {type=TEXT,value=foo},
nextToken() -> {type=CLOSE,value=c},
...
]

=end


class Node

  class ContentNotAllowed < StandardError; end

  attr_accessor :content, :children, :key_value
  def initialize
    @key_value = ''
    @content = ''
    @children = []
  end

  def << (child)
    #raise ContentNotAllowed unless content.nil?
    children << child
  end

  def content=(string)
    #raise ContentNotAllowed unless children == []
    content = string
  end
end

class Tokenizer
  def initialize
    @pointer = 0
    @tokenized_xml = [
      {type: 'BEGIN', value: 'a'},
      {type: 'BEGIN', value: 'b'},
      {type: 'BEGIN', value: 'c'},
      {type: 'TEXT',  value: 'foo'},
      {type: 'CLOSE', value: 'c'},
      {type: 'BEGIN', value: 'c'},
      {type: 'CLOSE', value: 'c'},
      {type: 'CLOSE', value: 'b'},
      {type: 'BEGIN', value: 'd'},
      {type: 'TEXT',  value: 'blah'},
      {type: 'CLOSE', value: 'd'},
      {type: 'CLOSE', value: 'a'},
      ]
  end

  def nextToken
    value = @tokenized_xml[@pointer]
    @pointer += 1
    value
  end

end

def buildXML(tokenizer, node = nil)
  token = tokenizer.nextToken
  return node if token.nil?

  type = token[:type]
  if type == 'CLOSE'
    buildXML(tokenizer, node)
    return node
  end
  new_node = Node.new

  case type
  when 'BEGIN'
    new_node.key_value = token[:value]
    node << new_node unless node.nil?
    buildXML(tokenizer, new_node)

  when 'TEXT'
    new_node.content = token[:value]
    node << new_node unless node.nil?
    buildXML(tokenizer, node)
  end

  new_node
end

RSpec.describe Node do
  it 'works' do
    tokenizer = Tokenizer.new
    result = buildXML(tokenizer)
    binding.pry
  end
end
