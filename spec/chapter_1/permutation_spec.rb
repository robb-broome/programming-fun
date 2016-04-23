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

