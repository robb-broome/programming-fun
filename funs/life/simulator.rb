require 'pry'
class Field
  KILL_VAL = 5
  SPAWN_VAL = 3

  attr_reader :rows, :cols, :cells
  def initialize rows, cols
    @rows = rows
    @cols = cols
    @cells = {}

    rows.times do |row|
      cols.times do |col|
        cells[[row, col]] = Cell.new(state: 0, row: row, col: col)
      end
    end
  end

  def advance
    cells.each do |addr, cell|
      count = neighbor_count_for(cell)
      if count >= KILL_VAL
        cell.kill
      elsif count >= SPAWN_VAL
        cell.spawn
      end
    end
  end

  def print
    rows.times do |row|
      cols.times do |col|
        STDOUT.print cells[[row,col]].to_s
      end
      puts
    end
  end

  def value_at cell_addr
    cell = cells[cell_addr]
    return 0 if cell.nil?
    cell.state
  end

  def neighbor_count_for cell
    val = 0
    (-1..1).each do |x|
      (-1..1).each do |y|
        next if x == 0 && y == 0
        row, col = cell.row + y, cell.col + x
        val += value_at [row, col]
      end
    end
    val
  end
end

class Cell
  attr_accessor :state, :row, :col
  def initialize state: false, row:, col:
    @row = row
    @col = col
    @state = state
  end

  def to_s
    self.state == 1 ? 'x' : '.'
  end

  def spawn
    self.state = 1
  end

  def kill
    self.state = 0
  end

  def flip
    self.state = state == 0 ? 1 : 0
    self
  end
end

field = Field.new 25,70
field.cells[[20,50]].flip
field.cells[[21,51]].flip
field.cells[[21,50]].flip
field.cells[[21,49]].flip
field.print
binding.pry
100.times do
field.print
field.advance
end
