require_relative '../common'

class String
  def unshift
    val = self[0]
    replace self[1..-1]
    val
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

  def unique?
    pos = -1
    loop do
      break unless char = self[pos += 1]
      check = pos
      loop do
        break unless check_char = self[check += 1]
        return false if char == check_char
      end
    end
    true
  end

  def permutation_of? other
    self.to_a.sort == other.to_a.sort
  end

  def to_a
    self.split //
  end
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

require 'spec_helper'

RSpec.describe String do
  it 'sorts' do
    #comment
  end

  describe 'unshift' do
    it 'returns the first char' do
      expect('abc'.unshift).to eq 'bc'
    end

    it 'mutates the string' do
      string = 'abc'
      expect{ string.unshift }.to change{string}.from('abc').to('bc')
    end
  end
  describe 'permutations' do
    it 'finds them' do
      base = 'abcdef'
      perm = 'abdcef'
      expect(perm.permutation_of?(base)).to be_truthy
    end

    it 'finds non-permutaions' do
      base = 'abcdef'
      perm = 'xbdcef'
      expect(perm.permutation_of?(base)).to be_falsey
    end
  end

  describe 'rotations' do
    it 'rotates' do
      expect('abc'.rotate(1)).to eq('bca')
      expect('abc'.rotate(2)).to eq('cab')
      expect('abc'.rotate(3)).to eq('abc')
    end

    it 'is a rotation' do
      base = 'abcdef'
      try = 'bdcefa'
      expect(try.is_rotation_of?(base)).to be_truthy
    end
  end

  describe 'uniqueness' do
    it 'is unique' do
      expect('abcdef'.unique?).to be_truthy
    end

    it 'is not unique' do
      expect('abddef'.unique?).to be_falsey
    end
    it 'is unique if single' do
      expect('a'.unique?).to be_truthy
    end
  end

end

