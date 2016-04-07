require 'spec_helper'

RSpec.describe 'Chapter 1' do
  describe Matrix do
    it 'retuns a Matrix' do
      expect(Matrix.new(rows: 1,columns: 1)).to be_a Matrix
    end

    context 'a Matrix' do
      let(:default_value) { 'x' }
      let(:matrix) { Matrix.new rows: 3, columns: 3, default: default_value }

      it 'is addressable by r: c: ' do
        expect(matrix[2,2]).to eq default_value
      end

    end
  end
end

