# frozen_string_literal: true
require 'pry'

class MyString < String

  def mutate_my_string
    upcase!
  end

  def interpolate_my_string
    "#{upcase}"
  end

  def ~
    # Do a ROT13 transformation - http://en.wikipedia.org/wiki/ROT13
    tr 'A-Za-z', 'N-ZA-Mn-za-m'
  end
end

RSpec.describe MyString do
  subject(:my_string) { described_class.new }
  let(:this) { described_class.new('this').freeze }

  describe 'changing unary operators' do
    it 'does rot13' do
      expect( ~this ).to eq('guvf')
    end
  end

  describe 'mutable' do
    specify 'interpolated ("dynamic") strings are mutable' do
      new_string = this.interpolate_my_string
      expect( this).to eq('this')
      expect{ new_string << 'extra' }.not_to raise_error
      expect{ new_string << 'extra' }.not_to raise_error
      expect{ new_string.upcase! }.not_to raise_error
      new_string.freeze
      expect{ new_string.upcase! }.to raise_error(FrozenError)
    end

    it 'does not allow' do
      expect{ this.mutate_my_string }.to raise_error(FrozenError)
    end

    it 'does allow if you unfreeze' do
      expect(this.frozen?).to be_truthy
      that = +this
      expect(that.frozen?).to be_falsey
      that.mutate_my_string
      expect(that).to eq('THIS')
    end
  end
end
