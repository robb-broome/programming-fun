require 'pry'
GRID_ROWS = 60
GRID_COLS = 100
DELAY = 0.001
LIFETIME = 1000000
class Field
  KILL_VAL = 5
  P_KILL = 0.01

  SPAWN_VAL = 4
  P_SPAWN = 0.001

  RANDOMNESS = true
  NEIGHBOR_RANGE = 1


  attr_reader :rows, :cols, :cells

  @@iter_count = -1
  @@magic_kills = 0
  @@magic_births = 0

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
      if RANDOMNESS && Kernel.rand > (1.00 - P_SPAWN)
        @@magic_births += 1
        cell.spawn
      elsif RANDOMNESS && Kernel.rand > (1.00 - P_KILL)
        @@magic_kills += 1
        cell.kill
      elsif count >= KILL_VAL
        cell.kill
      elsif count >= SPAWN_VAL
        cell.spawn
      end
    end
  end

  def print
    val = "--#{@@iter_count += 1}-- magic kills:#{@@magic_kills} magic births: #{@@magic_births}\n"
    rows.times do |row|
      cols.times do |col|
        item = cells[[row,col]].to_s
        val << item
      end
      val << "|\n"
    end
    val << '-' * GRID_ROWS
    STDOUT.write val
  end

  def value_at cell_addr
    cell = cells[cell_addr]
    return 0 if cell.nil?
    cell.state
  end

  def neighbor_count_for cell
    val = 0
    (-NEIGHBOR_RANGE..NEIGHBOR_RANGE).each do |x|
      (-NEIGHBOR_RANGE..NEIGHBOR_RANGE).each do |y|
        next if x == 0 && y == 0
        row, col = cell.row + y, cell.col + x
        neighbor_value = value_at [row, col]
        distance =[ x, y].max
        # val += neighbor_value.to_f / distance.to_f
        val += neighbor_value
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
    self.state == 1 ? 'x' : ' '
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

field = Field.new GRID_ROWS, GRID_COLS
field.cells[[20,50]].flip
field.cells[[21,51]].flip
field.cells[[21,50]].flip
field.cells[[21,49]].flip
field.cells[[21,48]].flip
system 'clear'
field.print
sleep 1
system 'clear'
LIFETIME.times do
  system 'clear'
  field.print
  sleep DELAY
  field.advance
end
