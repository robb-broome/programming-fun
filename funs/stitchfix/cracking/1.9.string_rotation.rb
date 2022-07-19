def is_rotation?(s1, s2)
  (s1 + s1).include?(s2)
end


RSpec.describe 'is_rotation?' do
  subject(:rot_test) { is_rotation?(s1, s2) }
  context 'when they are a rotation' do
    let(:s1) { 'waterbottle' }
    let(:s2) { 'erbottlewat' }
    it 'accepts' do
      expect(rot_test).to be_truthy
    end
  end
  context 'when they are not a rotation' do
    let(:s1) { 'waterbottlerx' }
    let(:s2) { 'erbottlewatzy' }
    it 'rejects' do
      expect(rot_test).to be_falsey
    end
  end

  context 'when strings are not the same length' do
    let(:s1) { 'waterb' }
    let(:s2) { 'erbottlewatzy' }
    it 'rejects' do
      expect(rot_test).to be_falsey
    end
  end
end
