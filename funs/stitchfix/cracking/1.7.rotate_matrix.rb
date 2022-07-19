require 'pry'

class Matrix
  attr_reader :dimension
  def initialize(n)
    @dimension = n
  end

  def matrix
    Array.new(dimension) {|n| row(n)}
  end

  def row(row_number)
    (1..dimension).map {|n| "#{row_number}-#{n}" }
  end

end

class Rotator
  attr_reader :matrix, :dimension
  def initialize(matrix)
    @matrix = matrix
    @dimension = matrix.count
  end

  def rot(count = 1)
    dimension.times do |row|
      dimension.times do |column|

    end
  end
end

RSpec.describe Rotator do
  let(:matrix) { Matrix.new(dimension).matrix}
  let(:dimension) {2}
  it 'rotates one position right' do
  end
end
RSpec.describe Matrix do
  subject(:matrix) { Matrix.new(dimension) }
  let(:dimension) { 5 }
  it 'fills the matrix uniquely' do
    m = matrix.matrix
  end
  it 'makes an array with expected row count' do
    expect(matrix.matrix.count).to eq(dimension)
  end
  it 'makes an array with expected col count' do
    generated = matrix.matrix
    generated.each do |row|
      expect(row.count).to eq(dimension)
    end
  end
end
