require_relative '../common'

class String
  def unshift
    self[0]
  end

  def rotate(num)
    rotation = num % self.length
    return self if rotation == 0
    self.class.new self[rotation..-1] + self[0..rotation -1]
  end

  def is_rotation_of?(other)
    return true if other == self
    self.length.times do |rotation|
      return true if other.rotate(rotation) == self
    end
    false
  end
end

def unique? str
  pos = -1
  loop do
    break unless char = str[pos += 1]
    check = pos
    loop do
      break unless check_char = str[check += 1]
      return false if char == check_char
    end
  end
  true
end

class Matrix
  require 'pry'
  attr_accessor :value, :rowcount, :colcount
  def initialize rows:, columns:, default: nil
    @rowcount = rows
    @colcount = columns

    @value = rows.times.map { |rownum| Array.new(columns) }

    rowcount.times do |rownum|
      colcount.times do |colnum|
        @value[rownum][colnum] = if ( default.is_a?(Matrix) || default.is_a?(Array) )
                                   default[rownum,colnum]
                                 elsif default
                                   default
                                 else
                                   "(#{rownum},#{colnum})"
                                 end
      end
    end
  end

  define_method(:[]) do | a, b |
    value[a][b]
  end

  define_method(:[]=) do |a, b, val|
    value[a][b] = val
  end

  def print
    value.each_with_index do |row, index|
      puts  value[index].join ', '
    end
    nil
  end

  def print_map
    value.length.times do |row_index|
      row = value[row_index]
      [].tap do |printed|
        row.length.times do |col_index|
          printed << "[#{row_index}, #{col_index}]"
        end
        puts printed.join ', '
      end
    end
    nil
  end

  def rot(direction: :right)
    newmatrix = [].tap do |new_matrix|
      rowcount.times do |rownum|
        new_matrix << colcount.times.map { |colnum| self[colnum, rownum] }
      end
    end
    Matrix.new(rows: colcount, columns: rowcount, default: newmatrix)
  end
end

