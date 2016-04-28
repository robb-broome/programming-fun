class RParser
  class << self
    def parse str
      new(str).parse
    end
  end

  OPEN = '{'
  CLOSE = '}'

  attr_reader :str
  def initialize str
    puts "INIT WITH STR #{str}"
    @str = str
  end

  def parse
    chunk = chunker
    puts "PARSE got chunk [#{chunk}]"
    if chunk.include?(':')
      partn = chunk.partition(':')
      key = partn[0].strip
      val = partn[2].strip
      puts "KEY VAL [#{key}] [#{val}]"
      Hash[ key, RParser.parse(val) ]
    else
      chunk
    end
  end

  def chunker
    return nil unless str
    puts "CHUNKER GOT str == [#{str}]"
    nesting_level = 0
    index = 0
    open_ptr = close_ptr = nil
    str.each_char do |char|
      case char
      when OPEN
        nesting_level += 1
        puts "OPEN DETECTED"
        puts "NESTING LEVEL IS #{nesting_level}"
        open_ptr ||= index
      when CLOSE
        nesting_level -= 1
        if nesting_level > 0
          index += 1
          next
        end
        close_ptr = index
        puts "CLOSE DETECTED at #{close_ptr}"
        puts "nesti DETECTED at #{nesting_level}"
        puts "CLOSE DETECTED at #{str}"
        puts "CLOSE DETECTED at #{'0123456789' * ((close_ptr/10) + 1)}"
        break
      end
      index += 1
    end
    if open_ptr == nil && close_ptr == nil
      open_ptr = 0
      close_ptr = index
    end
    range = (open_ptr + 1)...(close_ptr)
    puts "RANGE #{range}"
    chunk = str[range].strip
    puts "CHUNKER returns [#{chunk}]"
    chunk
  end
end
