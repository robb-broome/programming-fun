require 'pry'
class RubyBasicObject
  def self.class_method_mine; end
  def instance_method_mine; end
end

RSpec.describe RubyBasicObject do
  it 'has instance methods' do
    expect(described_class.instance_methods(false)).to eq [:instance_method_mine]
  end

  it 'has class methods' do
    expect(described_class.methods(false)).to eq [:class_method_mine]
  end

  it 'does not inherit' do
    expect(described_class.ancestors).to be_nil
  end
end
