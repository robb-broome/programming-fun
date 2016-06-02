require 'rspec'

class Numeric
  def commatize!
    s = self.to_s
    s.gsub /(?<=\d)(?=(\d\d\d)+$)/, ','
  end
end

RSpec.describe 'Commatizer' do
  it 'commatizes millions' do
    expect(1_000_000.commatize!).to eq('1,000,000')
  end

  it 'commatizes billions' do
    expect(1_899_877_898.commatize!).to eq('1,899,877,898')
  end

  it 'leaves hundreds alone' do
    expect(123.commatize!).to eq('123')
  end

  it 'even works on thousands' do
    expect(1_234.commatize!).to eq('1,234')
  end

end
