require 'rspec'

class LineCheck
  def initialize(coords:, evaluator:)
    @evaluator = evaluator.new(coords)
  end

  def straight?
    @evaluator.straight?
  end
end

class CrossProductEvaluator
  require 'matrix'
  def initialize(coords)
    @origin = coords.shift
    point_one = coords.shift
    @base_vector = normal_vector(point_one)
    @coords = coords
  end

  def straight?
    coords.all? {|point| test_angle( normal_vector(point) ) == 0.0 }
  end

  private
  attr_reader :coords, :origin, :base_vector

  def test_angle(vector)
    angle = base_vector.angle_with(vector)
    angle.round(5)
  end

  def normal_vector(point)
    Vector[ point[0] - origin[0], point[1] - origin[1] ]
  end
end

class AngleEvaluator

  def initialize(coords)
    @origin = coords.shift
    point_one = coords.shift
    @expected_sin = sin(origin, point_one)
    @coords = coords
  end

  def straight?
    coords.all? {|point| expected_sin == sin(origin, point) }
  end

  private

  attr_reader :coords, :origin, :expected_sin

  def sin(origin, point)
    d_x = point[0] - origin[0]
    d_y = point[1] - origin[1]
    hypotenuse = Math.sqrt( d_x ** 2 + d_y ** 2 )
    (d_y.to_f / hypotenuse).round(5)
  end
end


RSpec.describe 'straight lines' do
  let(:really_straight_line) { [[1,1],[2,2],[3,3],[4,4],[5,5],[6,6]] }
  let(:straight_line) { [[1,2],[2,3],[3,4],[4,5],[5,6],[6,7]] }
  let(:crooked_line) { [[1,1],[2,2],[3,4],[4,5],[5,6],[7,7]] }
  let(:sin_of_45_degrees) { (0.7071067811865475).round(5) }
  describe 'AngleEvaluator::sin' do
    let(:origin) { [0, 0] }

    subject{ AngleEvaluator.sin(origin, [x, y]) }
    context 'it is 90 degrees' do
      let(:x) { 0 }
      let(:y) { 10 }
      it {is_expected.to eq(1.00)}
    end
    context 'it is 0 degrees' do
      let(:x) { 80 }
      let(:y) { 0 }
      it {is_expected.to eq(0.00)}
    end
    context 'it is 45 degrees' do
      let(:x) { 80 }
      let(:y) { x }
      it {is_expected.to eq(sin_of_45_degrees)}
    end
    context 'it is 45 degrees' do
      let(:x) { 10 }
      let(:y) { x }
      it {is_expected.to eq(sin_of_45_degrees)}
    end
  end

  shared_examples_for 'a straight line checker' do |evaluator|
    subject { LineCheck.new(coords: coords, evaluator: evaluator).straight? }
    context 'when the line is not straight' do
      let(:coords) { crooked_line }
      it { is_expected.to be_falsey }
    end

    context 'when the line is really straight' do
      let(:coords) { really_straight_line }
      it { is_expected.to be_truthy }
    end

    context 'when the line is straight' do
      let(:coords) { straight_line }
      it { is_expected.to be_truthy }
    end
  end

  describe LineCheck do
    it_behaves_like 'a straight line checker', AngleEvaluator
    it_behaves_like 'a straight line checker', CrossProductEvaluator
  end
end
