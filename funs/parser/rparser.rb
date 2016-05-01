require 'pry'
module Writer
  LOUD = true
  def wrt str
    puts str if LOUD
  end
end

class BaseNode
  include Writer
  OPEN, CLOSE, partition_char = nil
  attr_accessor :val, :chunk

  def initialize value: nil, chunk: nil
    @chunk = chunk
  end

  def partition str, by: nil
    by ||= partition_char
    wrt "PARTITIONING using #{by}"
    return str unless partition_char
    reg = /([^#{by}]+)#{by}(.+)/
    match = str.match reg
    [match[1].strip, match[2].strip]
  end

  def value
    chunk
  end
  def parse
    wrt "#{self.class.name}.PARSE got chunk [#{chunk.inspect}]"
  end
end

class HashNode < BaseNode
  # contains value [HashAssoc, HashAssoc, ... ]

  OPEN, CLOSE = '{', '}'
  def partition_char; ':'; end

  def initialize opts
    # internal value array
    @val = []
    super opts
  end

  def value
    parse
    intermediate = val.map do |v|
      v.map do |element|
        element.respond_to?(:value) ? element.value : element
      end
    end
    Hash[intermediate]
  end

  def parse
    super
    # grab the first 'word' (delimited by quote)
    # then grab the next thing: either ',' or ':'
    first_word = chunk.match(/"(\w+)"/)[1]

    # break by commas first, then iterate
    # but this doesn't work if the comma is in a sub-element.
    # Get the first key.
    parts = partition(chunk, by: ':')
    wrt "PARTITION got #{parts.inspect}"
    val << [ RParser.parse(parts[0]), RParser.parse(parts[1]) ]

    self
  end
end

class ArrayNode < BaseNode
  # contains value [Array, Hash, Node, ... ]

  OPEN, CLOSE = '[', ']'

  def initialize opts
    @val = []
    super opts
  end

  def partition_char; ','; end

  def parse
    super
    val.push(chunk.split(partition_char)).flatten
  end

  def value
    val.map(&:value)
  end
end

class LeafNode < BaseNode
  #contains value = 'the value'
  def initialize opts
    @value = ''
    super opts
  end

  def parse
    super
    match = chunk.match(/["']?([^"]+)["']?/)
    value = match[1]
    return value.to_i if value =~ /^\d+$/
    value

  end
end

class RParser
  include Writer
  class << self
    def parse str
      new(str).parse
    end
  end


  # does HashNode know how to parse the chunk?

  # how to parse a json with an AST
  # find the first open, decide on what data type (array, hash)
  # grab the chunk
  # initialize a new (array | hash) with chunk 
  # if it's a hash, it has an array of hash-pairs 
  #     (what are these? associations? 
  #     value = [[key, val],[key, val]]
  #
  # - decide how many hash-pairs
  # - first 'word' is a key (up to :), 
  # - rest is 'val'
  #   - for the first association, make an object 
  #     - key = key 
  #     - value = value
  # - parse val, decide what kind. it can be:
  #   - array (opening [) - find close, parse it
  #   - hash (opening {) - find close, parse it
  #   - simple value (word)
  #   - 
  # 

  attr_reader :str
  def initialize str
    wrt "INIT WITH STR #{str}"
    @str = str
  end

  def parse
    chunker.parse
  end

  private

  def class_for token
    klass = {'{' => HashNode, '[' => ArrayNode}[token] || LeafNode
    wrt "KLASS #{klass} detected"
    klass
  end

  def chunker
    return nil unless str
    wrt "CHUNKER GOT str == [#{str}]"
    nesting_level = 0
    index = 0
    open_ptr, close_ptr = nil
    klass = class_for str[0]
    str.each_char do |char|
      case char
      when klass::OPEN
        nesting_level += 1
        wrt "OPEN DETECTED"
        wrt "NESTING LEVEL IS #{nesting_level}"
        open_ptr ||= index
      when klass::CLOSE
        nesting_level -= 1
        if nesting_level > 0
          index += 1
          next
        end
        close_ptr = index
        wrt "CLOSE DETECTED at #{close_ptr}"
        wrt "nesting level is: #{nesting_level}"
        wrt "................. #{str}"
        wrt "................. #{'0123456789' * ((close_ptr/10) + 1)}"
        break
      end
      index += 1
    end
    if open_ptr == nil && close_ptr == nil
      wrt "NO OPEN OR CLOSE FOUND"
      open_ptr = 0
      close_ptr = index
      klass = LeafNode
    end
    range = (open_ptr + 1)...(close_ptr)
    wrt "RANGE #{range}"
    chunk = str[range].strip
    val = klass.new( chunk: chunk)

    wrt "CHUNKER returns [#{val.inspect}]"
    val
  end
end


RSpec.describe RParser do
 # it 'parses a simple string' do
 #   ast = RParser.parse('{"name": "Robb"}')
 #   expect(ast.value).to eq({'name' => 'Robb'})
 #  end
 #  it 'parses a hash with two keys' do
 #    test = '{"name": "Robb", "age": 45}'
 #    expect(RParser.parse(test).value).to eq({'name' => 'Robb', 'age' => 45})
 #  end
  it 'parses a nested hash' do
    test = '{"person": {"name": "Robb", "age": 45}}'
    expect(RParser.parse(test).value).to eq({'person' => {'name' => 'Robb', 'age' => 45}})
  end
end
